defmodule Pamela.Trader.ExecuteTrade do
  def execute(trades, base) do
    Enum.map(trades, fn {coin, amount} ->
      amount_trunc = trunc_amount(amount)
      market = "#{coin}#{base.symbol}"
      exec(amount_trunc, market)
    end)
  end

  def exec(amount, market) when amount > 0 do
    Binance.order_market_buy(market, amount)
  end

  def exec(amount, market) when amount <= 0 do
    Binance.order_market_sell(market, -amount)
  end

  def trunc_amount(amount) when amount >= 1 do
    trunc(amount)
  end

  def trunc_amount(amount) when amount < 1 do
    amount
  end
end
