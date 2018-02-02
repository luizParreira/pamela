defmodule Pamela.Command.Handler do
  alias Nadia.Model.{User, Message}
  alias Pamela.User.TelegramUser
  alias Pamela.Telegram.Command
  alias Pamela.Command
  alias Pamela.Command.Executor
  alias Pamela.Telegram

  def handle(id, %Message{} = message, :command) do
    {:ok, %TelegramUser{} = user} = parse_user(message.from)

    {:ok, %Telegram.Message{} = msg} =
      Pamela.Telegram.create_message(%{
        user_id: user.id,
        update_id: id,
        text: message.text,
        type: "command"
      })

    save_and_execute_cmd(id, message, user)
  end

  def handle(id, %Message{} = message, :message) do
    {:ok, %TelegramUser{} = user} = parse_user(message.from)

    {:ok, %Telegram.Message{} = msg} =
      Pamela.Telegram.create_message(%{
        user_id: user.id,
        update_id: id,
        text: message.text,
        type: "message"
      })

    case Telegram.get_command_by(user_id: user.id, executed: false) do
      [] -> {:error, :handled_command}
      [command] -> Executor.execute(command, message, user)
      [command | _commands] -> Executor.execute(command, message, user)
    end
  end

  def handle(_id, _msg, _flag), do: {:error, :unknown_message}

  defp save_and_execute_cmd(id, message, user) do
    case Telegram.create_command(%{
           message_id: id,
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
