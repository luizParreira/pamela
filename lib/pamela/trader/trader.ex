defmodule Pamela.Trader do
  defdelegate rebalance(session), to: Pamela.Trader.Rebalance
end
