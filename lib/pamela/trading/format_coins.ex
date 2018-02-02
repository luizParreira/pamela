defmodule Pamela.Trading.FormatCoins do
  def format(coins) do
    base = Enum.find(coins, fn coin -> coin.base end)
    trading_coins = Enum.filter(coins, fn coin -> !coin.base end)

    symbols = Enum.map(coins, fn coin -> coin.symbol end)

    trading_pairs =
      Enum.map(coins, fn coin ->
        IO.inspect(coin)

        if !coin.base do
          "#{coin.symbol}#{base.symbol}"
        else
          coin.symbol
        end
      end)

    {symbols, trading_pairs}
  end
end
