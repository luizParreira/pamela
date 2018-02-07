defmodule Pamela.Command.Trade.Init do
  alias Pamela.Telegram.CommandMessage
  alias Pamela.Command.Messages
  alias Pamela.Telegram
  alias Pamela.Trading

  def run(command, message, user) do
    case Trading.get_session_by(user.id, true) do
      [] -> {:run, {command, message, user}}
      [session] -> resolve_command(command, message, user, session)
    end
  end

  def resolve_command(command, message, user, session) do
    if session.command_id != command.message_id do
      resolve_existing_command(user, command, session)
    else
      {:run, {command, message, user}}
    end
  end

  defp resolve_existing_command(user, command, session) do
    case Telegram.update_command(command, %{executed: true}) do
      {:ok, _cmd} -> Nadia.send_message(user.id, Messages.existing_session(session))
      _ -> {:error, :couldnt_update_command}
    end
  end
end
