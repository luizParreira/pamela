defmodule Pamela.Trader.ExecuteTrade do
  @binance_client Application.get_env(:pamela, :binance_client)

  def execute(trades, base, session, prices, transaction) do
    trades =
      Enum.map(trades, fn {coin, amount} ->
        amount_trunc = :erlang.float_to_binary(amount, decimals: 8)
        market = "#{coin}#{base.symbol}"

        case exec(amount_trunc, market) do
          {:ok, trade} ->
            save_trades(trade, coin, session, prices, transaction, base)

          {:error, error} ->
            IO.inspect(error)
            {:error, error}
        end
      end)

    {:ok, trades}
  end

  defp exec(amount, market) when amount > 0 do
    IO.inspect("ORDER: #{amount} MARKET: #{market}")
    @binance_client.order_market_buy(market, amount)
  end

  defp exec(amount, market) when amount <= 0 do
    IO.inspect("ORDER: #{amount} MARKET: #{market}")
    @binance_client.order_market_sell(market, -amount)
  end

  defp save_trades(trade, coin, _session, prices, transaction, base) do
    {_coin, price} = Enum.find(prices, fn {symbol, _p} -> symbol === coin end)

    attrs = %{
      amount: trade["executedQty"],
      base: base.symbol,
      coin: coin,
      price: Float.to_string(price),
      rebalance_transaction_id: transaction.id,
      side: trade["side"],
      order_id: trade["orderId"],
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
