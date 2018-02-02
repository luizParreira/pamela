defmodule Pamela.Command.Start do
  alias Pamela.User.TelegramUser
  alias Pamela.Telegram.Command
  alias Pamela.Telegram
  alias Pamela.Command.Messsages

  def run(%Command{} = command, %TelegramUser{} = user) do
    case Nadia.send_message(user.id, Messages.intro(user)) do
      {:ok, message} -> update_command(command)
      error -> {:error, error}
    end
  end

  defp update_command(command) do
    case Telegram.update_command(command, %{executed: true}) do
      {:ok, command} -> command
      {:error, error} -> error
    end
  end
end
