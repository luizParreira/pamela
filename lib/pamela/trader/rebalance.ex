defmodule Pamela.Trader.Rebalance do
  alias Pamela.Trading.Session
  alias Pamela.Trader.Allocation
  alias Pamela.BinanceEx
  alias Pamela.PAMR
  alias Pamela.Trading

  def rebalance(%Session{} = session) do
    {balances, prices} =
      case Trading.get_coins_by(session_id: session.id) do
        coins ->
          {Exchange.get_balance(%BinanceEx{}, coins), Exchange.get_prices(%BinanceEx{}, coins)}

        nil ->
          {:error, "No coins registered to session #{session.id}"}
      end

    {total, allocation} = Allocation.current(balances, prices)

    target = PAMR.run(0.7, 0.3, prices, prices, allocation)

    IO.puts(target)
  end

  def rebalance(other_session), do: {:error, "Unknown struct #{other_session}"}
end
