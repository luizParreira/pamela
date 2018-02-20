defmodule Pamela.Trader.RebalanceTask do
  use GenServer
  alias Pamela.Trading
  alias Pamela.Trader

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    # Schedule work to be performed at some point

    user_id = Application.get_env(:pamela, :allowed_user)

    args =
      case Trading.get_session_by(user_id, true) do
        [session] -> [session, Trading.get_period_by(session: session)]
        _value -> []
      end

    IO.puts("Initializing rebalacing task")

    schedule_work(args)
    {:ok, args}
  end

  def handle_info(:work, []) do
    schedule_work([])
    {:noreply, []}
  end

  def handle_info(:work, [%Trading.Session{} = session, %Trading.Period{} = period]) do
    Trader.rebalance(session)
    # Reschedule once more
    schedule_work([session, period])
    {:noreply, [session, period]}
  end

  defp schedule_work([session, period]) do
    case Float.parse(period.period) do
      {val, _rem} ->
        time = fetch_time(val)
        send_after(time, :work)

      :error ->
        :error
    end
  end

  defp schedule_work([]) do
    0.1
    |> fetch_time
    |> send_after(:work)
  end

  defp send_after(time, work) do
    Process.send_after(self(), work, time)
  end

  defp fetch_time(val) when val >= 1.0 do
    Kernel.trunc(val * 60 * 60 * 1000)
  end

  defp fetch_time(val) when val < 1.0 do
    Kernel.trunc(val * 60 * 1000)
  end
end
