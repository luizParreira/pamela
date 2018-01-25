defmodule Pamela.MessageHandler do

  alias Nadia.Model.{Update, Message}
  alias Pamela.Command.Handler
  def handle do
    case Nadia.get_updates do
      {:ok, update} -> parse_updates(update)
      {:error, error} ->
        IO.inspect(error)
        error
    end
  end

  defp parse_updates([]), do: []
  defp parse_updates([head | updates]) do
    IO.inspect head
    parse_update(head)
    parse_updates(updates)
  end

  defp parse_update(%Update{message: message, update_id: id}) do
    parse_command(message, id)
  end
  defp parse_command(%Message{from: user, text: text, entities: []}, _id) do
    {:error, :only_commands}
  end
  defp parse_command(%Message{from: user, text: text, entities: nil}, _id) do
    {:error, :only_commands}
  end
  defp parse_command(%Message{from: user, text: text, entities: entities}, id) do
    Enum.map(entities, fn entity ->
      case entity do
        %{type: "bot_command"} -> Handler.handle(id, text, user)
        _ -> {:error, :only_commands}
      end
    end)
  end
end
