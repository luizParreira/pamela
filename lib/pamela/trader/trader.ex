defmodule Pamela.Trader do
  defdelegate rebalance(opts), to: Pamela.Trader.Rebalance
  defdelegate rebalance, to: Pamela.Trader.Rebalance
end
