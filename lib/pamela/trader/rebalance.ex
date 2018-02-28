defmodule Pamela.Trader.Rebalance do
  alias Pamela.Trading.Session
  alias Pamela.Trader.Allocation
  alias Pamela.BinanceEx
  alias Pamela.PAMR
  alias Pamela.Trading
  alias Pamela.Trader.Trades
  alias Pamela.Trader.ExecuteTrade

  def rebalance(%Session{} = session, previous_prices) do
    {balances, prices, coins} =
      case Trading.get_coins_by(session_id: session.id) do
        nil ->
          {[], [], []}

        coins ->
          {Exchange.get_balance(%BinanceEx{}, coins), Exchange.get_prices(%BinanceEx{}, coins),
           coins}
      end

    IO.inspect(Enum.map(coins, fn c -> c.symbol end))
    IO.inspect(balances)
    IO.inspect(prices)

    base = Enum.find(coins, fn c -> c.base end)

    {total, allocation} = Allocation.current(balances, prices)
    IO.inspect(allocation)

    prev_prices = fetch_prices(previous_prices, prices)

    target = PAMR.run(0.7, 0.9, prices, prev_prices, allocation)

    margin = 0.005

    trades = Trades.generate(total * (1 - margin), prices, allocation, target, coins)
    IO.inspect(trades)

    orders = ExecuteTrade.execute(trades, base)
    IO.inspect(orders)

    balances = Exchange.get_balance(%BinanceEx{}, coins)
    prices = Exchange.get_prices(%BinanceEx{}, coins)

    {total, allocation} = Allocation.current(balances, prices)

    balances_formatted = format_coins(balances)

    allocation_formatted = format_coins(allocation)

    message = """
    Target:
    #{format_coins(target)}

    Balances:
    #{balances_formatted}

    Allocation:
    #{allocation_formatted}

    Total Base #{base.symbol} Value:
    #{total} #{base.symbol}
    """

    Nadia.send_message(session.telegram_user_id, message)
    {:ok, prices}
  end

  def rebalance(other_session, _prev_prices), do: {:error, "Unknown struct #{other_session}"}

  defp fetch_prices([], prices), do: prices
  defp fetch_prices(prev_prices, _prices), do: prev_prices

  def format_coins(coins) do
    coins
    |> Enum.map(fn {coin, balance} -> "#{coin} - #{balance}\n" end)
    |> Enum.join()
  end
end
