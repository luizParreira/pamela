defmodule Pamela.PeriodicTask do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work(state)
    {:ok, state}
  end

  def handle_info(:work, []) do
    {:noreply, []}
  end

  def handle_info(:work, [%Trading.Session{} = session]) do
    Trader.rebalance(session)
    # Reschedule once more
    schedule_work([session])
    {:noreply, [session]}
  end

  defp schedule_work([session, period]) do
    # In 10 seconds
    case Float.parse(period.period) do
      {val, _rem} -> sned_after(val)
      :error -> :error
    end
  end

  defp sned_after(time) do
    Process.send_after(self(), :work, time * 60 * 60 * 1000)
  end

  defp schedule_work(_state) do
    :do_noting
  end
end
