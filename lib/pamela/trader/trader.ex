defmodule Pamela.Trader do
  defdelegate rebalance, to: Pamela.Trader.Rebalance
end
