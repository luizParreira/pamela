defmodule Pamela.BinanceEx do
  defstruct []

  def get_balance(coins) do
    Exchange.get_balance(coins)
  end

  def get_prices(coins) do
    Exchange.get_prices(coins)
  end
end

defimpl Exchange, for: Pamela.BinanceEx do
  alias Pamela.BinanceEx.Balance

  @binance_client Application.get_env(:pamela, :binance_client)

  def get_balance(coins) do
    case @binance_client.get_account() do
      {:ok, %{"balances" => balances}} ->
        balances
        |> Enum.map(fn %{"asset" => asset, "free" => free, "locked" => locked} ->
          %Balance{asset: asset, free: free, locked: locked}
        end)
        |> get_balances_for(coins: coins)

      error ->
        error
    end
  end

  def get_prices(coins) do
    case @binance_client.get_all_prices() do
      {:ok, prices} -> get_prices_for(prices, coins: coins)
      error -> error
    end
  end

  defp get_balances_for([], _coins), do: []
  defp get_balances_for(_balances, coins: []), do: []

  defp get_balances_for(balances, coins: coins) do
    Enum.map(coins, fn coin ->
      balance = Enum.find(balances, fn balance -> balance.asset === coin.symbol end)
      {val, _rem} = Float.parse(balance.free)

      {coin.symbol, val}
    end)
  end

  defp get_prices_for([], _coins), do: []
  defp get_prices_for(_prices, coins: []), do: []

  defp get_prices_for(prices, coins: coins) do
    base = Enum.find(coins, fn c -> c.base end)

    Enum.map(coins, fn coin ->
      {price, _rem} =
        if coin.base do
          {1.0, ""}
        else
          price = Enum.find(prices, fn price -> price.symbol === coin.symbol <> base.symbol end)
          Float.parse(price.price)
        end

      {coin.symbol, price}
    end)
  end
end
