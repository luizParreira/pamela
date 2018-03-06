defmodule Pamela.Trader.Rebalance do
  alias Pamela.Trading.Session
  alias Pamela.Trader.Allocation
  alias Pamela.BinanceEx
  alias Pamela.PAMR
  alias Pamela.Trading
  alias Pamela.Trader.Trades
  alias Pamela.Trader.ExecuteTrade
  alias Pamela.Trader.SessionReport
  alias Timex.Duration
  alias Pamela.Trading.RebalanceTransaction
  alias Pamela.Trading.Period

  def rebalance do
    with {session, period} <- fetch_session_info(),
         {:ok, %RebalanceTransaction{} = transaction} <-
           Trading.find_or_create_transaction(session),
         {:ok, transaction} <- continue_with_rebalance(transaction, period),
         {balances, prices, coins} <- fetch_market_info(session),
         {total, allocation} <- Allocation.current(balances, prices),
         {:ok, previous_prices} <- Trading.fetch_previous_prices(transaction.id, coins),
         {:ok, base} <- fetch_base(coins),
         {:ok, target} <- {:ok, PAMR.run(0.8, 0.9, prices, previous_prices, allocation)},
         {:ok, trades} <-
           {:ok, Trades.generate(total * (1 - 0.005), prices, allocation, target, coins)},
         {:ok, orders} <- ExecuteTrade.execute(trades, base, session, prices, transaction),
         {:ok, new_balances} <- {:ok, Exchange.get_balance(%BinanceEx{}, coins)},
         {:ok, new_prices} <- {:ok, Exchange.get_prices(%BinanceEx{}, coins)},
         {total, new_allocation} <- Allocation.current(balances, prices) do
      SessionReport.report(base, session, target, new_balances, new_allocation, total)
    end
  end

  defp continue_with_rebalance(transaction, nil), do: {:error, :need_period}

  defp continue_with_rebalance(%RebalanceTransaction{} = transaction, %Period{} = period) do
    with {:ok, diff} <- {:ok, Timex.diff(DateTime.utc_now(), transaction.time, :minutes)},
         {val, _rem} <- Float.parse(period.period),
         {:ok, diff} <- debug_diff(diff),
         {:ok, true} <- {:ok, diff / 60.0 >= val} do
      {:ok, transaction}
    else
      _ -> {:error, :stop}
    end
  end

  def debug_diff(diff) do
    IO.puts("Duration diff")
    IO.inspect(diff)
    {:ok, diff}
  end

  defp fetch_prices([], prices), do: prices
  defp fetch_prices(prev_prices, _prices), do: prev_prices

  defp fetch_base(coins) do
    {:ok, Enum.find(coins, fn c -> c.base end)}
  end

  defp fetch_session_info do
    user_id = Application.get_env(:pamela, :allowed_user)

    case Trading.get_session_by(user_id, true) do
      [session] -> {session, Trading.get_period_by(session: session)}
      _value -> nil
    end
  end

  defp fetch_market_info(%Session{id: id}) do
    case Trading.get_coins_by(session_id: id) do
      nil ->
        nil

      coins ->
        {Exchange.get_balance(%BinanceEx{}, coins), Exchange.get_prices(%BinanceEx{}, coins),
         coins}
    end
  end
end
