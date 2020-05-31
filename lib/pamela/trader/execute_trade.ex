defmodule Pamela.Trader.ExecuteTrade do
  @binance_client Application.get_env(:pamela, :binance_client)

  def execute(trades, base, session, prices, transaction) do
    {:ok, info} = @binance_client.get_exchange_info()

    trades =
      Enum.map(trades, fn {coin, amount} ->
        market = "#{coin}#{base.symbol}"

        case exec(amount, market, info) do
          {:ok, trade} ->
            save_trades(trade, coin, session, prices, transaction, base)

          {:error, error} ->
            IO.inspect(error)
            {:error, error}
        end
      end)

    {:ok, trades}
  end

  defp exec(amount, market, info) when amount > 0 do
    new_amount = parse_amount(amount, market, info)
    market_info = Enum.find(info.symbols, fn symbol -> symbol["symbol"] == market end)
    amount_trunc = :erlang.float_to_binary(new_amount, decimals: market_info["quoteAssetPrecision"])
    IO.inspect("ORDER: #{amount_trunc} MARKET: #{market}")
    @binance_client.order_market_buy(market, amount_trunc)
  end

  defp exec(amount, market, info) when amount <= 0 do
    market_info = Enum.find(info.symbols, fn symbol -> symbol["symbol"] == market end)
    new_amount = parse_amount(-amount, market, info)
    amount_trunc = :erlang.float_to_binary(new_amount, decimals: market_info["baseAssetPrecision"])
    IO.inspect("ORDER: #{amount_trunc} MARKET: #{market}")
    @binance_client.order_market_sell(market, amount_trunc)
  end

  def parse_amount(amount, market, info) do
    market_info = Enum.find(info.symbols, fn symbol -> symbol["symbol"] == market end)
    lot_size_filter = Enum.find(market_info["filters"], fn filter -> filter["filterType"] == "LOT_SIZE" end)
    {min_qty, _} = Float.parse(lot_size_filter["minQty"])
    {step_size, _} = Float.parse(lot_size_filter["stepSize"])

    IO.inspect("MARKET #{market} MIN_QTY #{min_qty} STEP_SIZE #{step_size} AMOUNT #{amount}")

    get_amount(min_qty, step_size, amount)
  end

  defp get_amount(min, step, amount) when step == amount do
    amount
  end

  defp get_amount(min, step, amount) when amount <= min do
    amount
  end

  defp get_amount(min, step, amount) when amount > min do
    calculate_amount(step, amount, step)
  end

  defp calculate_amount(step, amount, value) when value == amount do
    amount
  end

  defp calculate_amount(step, amount, value) when value < amount do
    calculate_amount(step, amount, value + step)
  end

  defp calculate_amount(step, amount, value) when value > amount do
    value - step
  end

  defp save_trades(trade, coin, _session, prices, transaction, base) do
    {_coin, price} = Enum.find(prices, fn {symbol, _p} -> symbol === coin end)

    {order_id, _} = Integer.parse(trade["orderId"])

    attrs = %{
      amount: trade["executedQty"],
      base: base.symbol,
      coin: coin,
      price: Float.to_string(price),
      rebalance_transaction_id: transaction.id,
      side: trade["side"],
      order_id: order_id,
      time: DateTime.utc_now()
    }

    case Pamela.Trading.create_trade(attrs) do
      {:ok, trs} ->
        {:ok, trs}

      {:error, error} ->
        IO.inspect(error)
        {:error, error}
    end
  end

  defp trunc_amount(amount) when amount >= 1 do
    trunc(amount)
  end

  defp trunc_amount(amount) when amount < 1 and amount >= 0 do
    amount
  end

  defp trunc_amount(amount), do: trunc(amount)
end
