defmodule Pamela.Trader.Trades do
  def generate(total, [base | prices], allocation, target, coins) do
    trades =
      Enum.map(prices, fn {coin, price} ->
        {coin_t, target_val} =
          Enum.find(target, fn {coin_t, _targ} ->
            coin_t === coin
          end)

        {coin_allo, allo_val} =
          Enum.find(allocation, fn {coin_all, _allo} -> coin_all === coin end)

        diff = target_val - allo_val

        if diff != 0 do
          {coin, total * diff / price}
        end
      end)

    trades = Enum.filter(trades, & &1)
    Enum.sort(trades, fn {_c, v1}, {_c1, v2} -> v2 >= v1 end)
  end
end