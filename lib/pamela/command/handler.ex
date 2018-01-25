defmodule Pamela.Command.Handler do
  alias Nadia.Model.User
  alias Pamela.User.TelegramUser
  alias Pamela.Command.TelegramCommand
  alias Pamela.Command
  alias Pamela.Command.Executor

  def handle(id, command, %User{} = user) do
    {:ok, %TelegramUser{} = user} = parse_user(user)

    case Command.get_telegram_command(id) do
      nil -> save_and_execute_cmd(id, command, user)
      %TelegramCommand{} = _cmd -> {:ok, :handled_command}
    end
  end

  defp save_and_execute_cmd(id, command, user) do
    case Command.create_telegram_command(%{
           update_id: id,
           command: command,
           telegram_user_id: user.id
         }) do
      {:ok, command} -> Executor.execute(command, user)
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
