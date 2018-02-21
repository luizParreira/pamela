defmodule Pamela.Trader.Rebalance do
  alias Pamela.Trading.Session
  alias Pamela.Trader.Allocation
  alias Pamela.BinanceEx
  alias Pamela.PAMR
  alias Pamela.Trading

  def rebalance(%Session{} = session) do
    {balances, prices, coins} =
      case Trading.get_coins_by(session_id: session.id) do
        nil ->
          {:error, "No coins registered to session #{session.id}", []}

        coins ->
          {Exchange.get_balance(%BinanceEx{}, coins), Exchange.get_prices(%BinanceEx{}, coins),
           coins}
      end

    {total, allocation} = Allocation.current(balances, prices)
    target = PAMR.run(0.7, 0.3, prices, prices, allocation)

    margin = 0

    trades =
      Pamela.Trader.Trades.generate(total * (1 - margin), prices, allocation, target, coins)

    IO.inspect(trades)
  end

  def rebalance(other_session), do: {:error, "Unknown struct #{other_session}"}
end
