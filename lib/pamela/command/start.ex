defmodule Pamela.Command.Start do
  alias Pamela.User.TelegramUser
  alias Pamela.Command.TelegramCommand

  def run(%TelegramCommand{} = command, %TelegramUser{} = user) do
    case Nadia.send_message(user.id, Pamela.Command.Messages.intro(user)) do
      {:ok, message} -> update_command(command)
      error -> error
    end
  end

  def update_command(command) do
    case Pamela.Command.update_telegram_command(command, %{executed: true}) do
      {:ok, new_command} ->
        IO.inspect new_command
        command
      {:error, error} ->
        IO.inspect error
        error
    end
  end
end
