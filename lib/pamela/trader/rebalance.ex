defmodule Pamela.Trader.Rebalance do
  alias Pamela.Trading.Session
  alias Pamela.Trader.Allocation
  alias Pamela.PAMR
  alias Pamela.Trading
  alias Pamela.Trader.Trades
  alias Pamela.Trader.ExecuteTrade
  alias Pamela.Trader.SessionReport
  alias Pamela.Trading.RebalanceTransaction
  alias Pamela.Trading.Period

  def rebalance do
    rebalance(state: :update, now: DateTime.utc_now())
  end

  def rebalance(opts) do
    with {session, period} <- fetch_session_info(),
         {:ok, previous_transaction} <- Trading.fetch_latest_transaction(session),
         {:ok, _transaction} <- continue_with_rebalance(previous_transaction, period, opts),
         {:ok, %RebalanceTransaction{} = current_transaction} <-
           Trading.create_rebalance_transaction(%{
             session_id: session.id,
             time: opts[:now]
           }),
         {:ok, coins} <- fetch_session_coins(session),
         {balances, prices} <- fetch_market_info(coins),
         _balances <- save_balances(balances, current_transaction),
         {total, allocation} <- Allocation.current(balances, prices),
         {:ok, previous_prices} <-
           Trading.fetch_previous_prices(previous_transaction || current_transaction, coins),
         {:ok, base} <- fetch_base(coins),
         {:ok, target} <- PAMR.run(0.5, 500, prices, previous_prices, allocation),
         {:ok, trades} <- Trades.generate(total * (1 - 0.005), prices, allocation, target, coins),
         {:ok, _orders} <-
           ExecuteTrade.execute(trades, base, session, prices, current_transaction),
         {new_balances, new_prices} <- fetch_market_info(coins),
         {total, new_allocation} <- Allocation.current(new_balances, new_prices) do
      SessionReport.report(base, session, target, new_balances, new_allocation, total)
    end
  end

  defp continue_with_rebalance(transaction, _period, state: :init, now: _now),
    do: {:ok, transaction}

  defp continue_with_rebalance(nil, _period, _opts),
    do: {:ok, nil}

  defp continue_with_rebalance(_transaction, nil, _opts), do: {:error, :need_period}

  defp continue_with_rebalance(%RebalanceTransaction{} = transaction, %Period{} = period, opts) do
    with {:ok, diff} <- {:ok, Timex.diff(opts[:now], transaction.time, :minutes)},
         {val, _rem} <- Float.parse(period.period),
         {:ok, true} <- {:ok, diff / 60.0 >= val} do
      {:ok, transaction}
    else
      _ -> {:error, :stop}
    end
  end

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

  defp fetch_session_coins(%Session{id: id}) do
    case Trading.get_coins_by(session_id: id) do
      nil -> {:error, :not_found}
      coins -> {:ok, coins}
    end
  end

  defp fetch_market_info(coins) do
    {Pamela.BinanceEx.get_balance(coins), Pamela.BinanceEx.get_prices(coins)}
  end

  defp save_balances(balances, transaction) do
    Enum.map(balances, fn {coin, balance} ->
      case Trading.create_balance(%{
             balance: balance,
             coin: coin,
             rebalance_transaction_id: transaction.id
           }) do
        {:ok, balance} -> balance
        {:error, error} -> error
      end
    end)
  end
end
