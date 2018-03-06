defmodule Pamela.PeriodicTask do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, %{task: task} = state) do
    task.()
    # Reschedule once more
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # In 10 seconds
    Process.send_after(self(), :work, 10 * 1000)
  end
end
