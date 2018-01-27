defmodule Pamela.Command.Handler do
  alias Nadia.Model.{User, Message}
  alias Pamela.User.TelegramUser
  alias Pamela.Command.TelegramCommand
  alias Pamela.Command
  alias Pamela.Command.Executor

  def handle(id, %Message{} = message, :command) do
    {:ok, %TelegramUser{} = user} = parse_user(message.from)

    case Command.get_telegram_command(id) do
      nil -> save_and_execute_cmd(id, message, user)
      %TelegramCommand{} = _cmd -> {:ok, :handled_command}
    end
  end

  def handle(id, %Message{} = message, :message) do
    {:ok, %TelegramUser{} = user} = parse_user(message.from)

    case Command.get_telegram_command_by(user.id, false) do
      [] -> {:error, :handled_command}
      [command] -> Executor.execute(command, message, user)
      [command | _commands] -> Executor.execute(command, message, user)
    end
  end

  def handle(_id, _msg, _flag), do: {:error, :unknown_message}

  defp save_and_execute_cmd(id, message, user) do
    case Command.create_telegram_command(%{
           update_id: id,
           command: message.text,
           telegram_user_id: user.id,
           executed: false
         }) do
      {:ok, command} -> Executor.execute(command, message, user)
      {:error, error} -> {:error, error}
    end
  end

  defp parse_user(%User{} = user) do
    case Pamela.User.get_telegram_user(user.id) do
      nil -> Pamela.User.create_telegram_user(Map.from_struct(user))
      user -> {:ok, user}
    end
  end
end
