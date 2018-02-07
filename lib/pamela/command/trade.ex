defmodule Pamela.Command.Trade do
  alias Pamela.Telegram
  alias Pamela.Command
  alias Command.Trade.{Init, Intro, Coins, Period, Confirmation}

  def run(command, message, user) do
    case Init.run(command, message, user) do
      {:run, {command, message, user}} -> run_cmd(command, message, user)
      error -> error
    end
  end

  defp run_cmd(command, message, user) do
    case Telegram.get_command_message_by(telegram_command_update_id: command.message_id) do
      [] -> Intro.run(command, user)
      [command_msg] -> run(command_msg.message, command, message, user)
      [command_msg | _commands] -> run(command_msg.message, command, message, user)
    end
  end

  defp run("trade_intro", command, message, user) do
    Intro.handle(command, message, user)
  end

  defp run("trade_coins", command, message, user) do
    Coins.handle(command, message, user)
  end

  defp run("trade_period", command, message, user) do
    Period.handle(command, message, user)
  end

  defp run("trade_confirmation", command, message, user) do
    Confirmation.handle(command, message, user)
  end

  defp run(_unknwon, _c, _m, _u), do: {:error, :unknown_command}
end
