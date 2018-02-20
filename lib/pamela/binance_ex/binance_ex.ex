defmodule Pamela.BinanceEx do
  defstruct []

  def get_balances([], _coins), do: []
  def get_balances(_balances, coins: []), do: []

  def get_balances(balances, coins: coins) do
    Enum.map(coins, fn coin ->
      {balance, rem} =
        balances
        |> Enum.find(fn balance -> balance.asset === coin end)
        |> Float.parse()

      {coin, balance}
    end)
  end

  def get_prices([], _coins), do: []
  def get_prices(_prices, coins: []), do: []

  def get_prices(prices, coins: coins) do
    base = Enum.find(coins, fn c -> c.base end)

    Enum.map(coins, fn coin ->
      {price, _rem} =
        if coin.base do
          {1.0, ""}
        else
          Enum.find(prices, fn price -> price.symbol === coin.symbol <> base.symbol end)
          |> Float.parse()
        end

      {coin, price}
    end)
  end
end

defimpl Exchange, for: Pamela.BinanceEx do
  alias Pamela.BinanceEx.Balance

  def get_balance(self, coins) do
    case Binance.get_account() do
      {:ok, %{"balances" => balances}} ->
        balances
        |> Enum.map(fn %{"asset" => asset, "free" => free, "locked" => locked} ->
          %Balance{asset: asset, free: free, locked: locked}
        end)
        |> self.get_balances(coins: coins)

      error ->
        error
    end
  end

  def get_prices(self, coins) do
    case Binance.get_all_prices() do
      {:ok, prices} -> self.get_prices(prices, coins: coins)
      error -> error
    end
  end
end
