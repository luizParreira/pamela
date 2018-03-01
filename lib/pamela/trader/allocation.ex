defmodule Pamela.Trader.Allocation do
  def current(balances, prices) do
    IO.inspect(balances)

    base_balances =
      Enum.map(balances, fn {coin, balance} ->
        {_coin, price} = Enum.find(prices, fn {coin_price, price} -> coin === coin_price end)
        {coin, price * balance}
      end)

    total =
      base_balances
      |> Enum.map(fn {coin, base_balance} -> base_balance end)
      |> Enum.sum()

    allocation = Enum.map(base_balances, fn {coin, b} -> {coin, b / total} end)
    {total, allocation}
  end
end
