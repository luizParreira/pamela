defmodule Pamela.PAMR do
  def run(insensitivity, aggressiveness, prices, previous_prices, allocation) do
    returns =
      prices
      |> Enum.map(fn {coin, price} ->
        previous_price =
          Enum.find(previous_prices, fn {price_coin, price} ->
            price_coin == coin
          end)

        {coin, price / previous_price}
      end)

    position = dot(allocation, returns)
    loss = max(0.0, position - insensitivity)

    returns_sum =
      returns
      |> Enum.map(fn {coin, ret} -> ret end)
      |> Enum.sum()

    mean = returns_sum / Enum.count(returns)

    returns_mean = Enum.map(returns, fn {coin, ret} -> {coin, ret - mean} end)
    returns_mean_squared = Enum.map(returns_mean, fn {coin, m} -> {coin, :math.pow(m, 2)} end)

    tau =
      Enum.map(returns_mean_squared, fn {coin, ret} ->
        {coin, loss / (ret + 1.0 / (2.0 * aggressiveness))}
      end)

    next_allocation =
      Enum.map(allocation, fn {coin, allo} ->
        {_coin, t} = Enum.find(tau, fn {coin_t, _t} -> coin_t === coin end)
        {_coin, ret} = Enum.find(returns_mean, fn {coin_r, _r} -> coin_r === coin end)
        {coin, (allo - t) * ret}
      end)

    next_allocation_sorted =
      Enum.sort(next_allocation, fn {_coin, v}, {_c, v2} ->
        v2 >= v
      end)

    tmax = simplex_proj(next_allocation_sorted, next_allocation_sorted, 0.0, 0.0, 0)

    Enum.map(next_allocation, fn {coin, allo} ->
      {coin, max(allo - tmax, 0.0)}
    end)
  end

  defp simplex_proj([], allocations, tmp, tmax, _i) do
    count = Enum.count(allocations)
    {coin, alloc} = Enum.at(allocations, count - 1)
    (tmp + alloc - 1.0) / count
  end

  defp simplex_proj([{coin, allo} | tail], allocations, tmpsum, tmax, i) do
    {coin, val} = Enum.at(tail, 0)

    if tmax >= val do
      tmax
    else
      simplex_proj(tail, tmpsum + allo, allocations, (tmpsum + allo - 1.0) / (i + 1), i + 1)
    end
  end

  defp dot(allocation, returns) do
    allocation
    |> Enum.map(fn {coin, allocation} ->
      asset_return =
        Enum.find(returns, fn {coin_return, return} ->
          coin === coin_return
        end)

      allocation * asset_return
    end)
    |> Enum.sum()
  end
end
