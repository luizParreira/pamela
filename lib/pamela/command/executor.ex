defmodule Pamela.Command.Executor do
  alias Pamela.User.TelegramUser
  alias Pamela.Command.TelegramCommand

  def execute(%TelegramCommand{} = command, %TelegramUser{} = user) do
    Nadia.send_message(user.id, "Saved command #{command.command}")
  end
end
