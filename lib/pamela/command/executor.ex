defmodule Pamela.Command.Executor do
  alias Pamela.User.TelegramUser
  alias Pamela.Telegram
  alias Pamela.Command

  def execute(%Telegram.Command{} = command, message, %TelegramUser{} = user) do
    execute_command(command.command, command, message, user)
  end

  defp execute_command("/start", command, _message, user) do
    Command.Start.run(command, user)
  end

  defp execute_command("/trade", command, message, user) do
    Command.Trade.run(command, message, user)
  end

  defp execute_command("/halt", command, _message, user) do
    Command.Halt.run(command, user)
  end
end
