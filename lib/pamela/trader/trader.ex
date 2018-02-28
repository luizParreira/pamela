defmodule Pamela.Trader do
  defdelegate rebalance(session, prev_prices), to: Pamela.Trader.Rebalance
end
