defmodule Pamela.Trader.RebalanceTask do
  use GenServer
  alias Pamela.Trading
  alias Pamela.Trader

  def start_link do
    user_id = Application.get_env(:pamela, :allowed_user)

    IO.puts("UserID: #{user_id}")

    args =
      case Trading.get_session_by(user_id, true) do
        [session] -> [session, Trading.get_period_by(session: session)]
        _value -> []
      end

    GenServer.start_link(__MODULE__, args)
  end

  def init([session, period]) do
    # Schedule work to be performed at some point
    schedule_work([])
    {:ok, {[session, period], []}}
  end

  def init([]), do: {:noreply}

  def init(other), do: IO.inspect(other)

  def handle_info(:work, []) do
    {:noreply, []}
  end

  def handle_info(
        :work,
        {[%Trading.Session{} = session, %Trading.Period{} = period], prev_prices}
      ) do
    case Trading.get_session(session.id) do
      session -> handle_rebalance(session, period, prev_prices)
      nil -> {:noreply, []}
    end
  end

  def handle_info(:work, _state), do: {:noreply, []}

  def handle_rebalance(%Trading.Session{running: true, id: _id} = session, period, prev_prices) do
    {:ok, prices} = Trader.rebalance(session, prev_prices)
    # Reschedule once more
    schedule_work([session, period])
    {:noreply, {[session, period], prices}}
  end

  def handle_rebalance(_sess, _period, _prev_prices), do: {:noreply, []}

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
    send_after(0, :work)
  end

  defp send_after(time, work) do
    Process.send_after(self(), work, time)
  end

  defp fetch_time(val) do
    Kernel.trunc(val * 60 * 60 * 1000)
  end
end
