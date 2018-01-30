defmodule Pamela.Command.Halt do
  alias Pamela.Command
  alias Pamela.Trading

  def run(command, user) do
    case Trading.get_session_by(user.id, true) do
      nil -> Nadia.send_message(user.id, Command.Messages.no_session())
      [session] -> resolve_state(command, session, user)
      _ -> {:error, :more_than_one_session_alive}
    end
  end

  defp resolve_state(command, session, user) do
    with {:ok, session} <- Trading.update_session(session, %{running: false}),
         {:ok, _msg} <- Nadia.send_message(user.id, Command.Messages.session_halted(session)),
         {:ok, cmd} <- Command.update_telegram_command(command, %{executed: true})
    do
      {:ok, :state_resolved}
    else
      _ -> {:error, :could_not_update_session}
    end
  end
end
