defmodule Pamela.MessageHandler do

  alias Nadia.Model.{Update, Message}
  alias Pamela.Command
  def handle do
    case Nadia.get_updates do
      {:ok, update} -> parse_updates(update)
      {:error, error} -> error
    end
  end

  defp parse_updates(nil), do: []
  defp parse_updates([]), do: []
  defp parse_updates([head | updates]) do
    case Command.get_telegram_command(head.update_id) do
      nil -> parse_update(head)
      _ -> {:error, :already_parsed}
    end
    parse_updates(updates)
  end

  defp parse_update(%Update{message: message, update_id: id}) do
    parse_command(message, message.entities, id)
  end
  defp parse_command(%Message{} = message, [], id) do
    Command.Handler.handle(id, message, :message)
  end
  defp parse_command(%Message{} = message, nil, id) do
    Command.Handler.handle(id, message, :message)
  end
  defp parse_command(%Message{} = message, entities, id) do
    Enum.map(entities, fn entity ->
      case entity do
        %{type: "bot_command"} -> Command.Handler.handle(id, message, :command)
        _ -> Command.Handler.handle(id, message, :message)
      end
    end)
  end
end
