defmodule Pamela.Command.Trade.Intro do
  alias Pamela.Command.Messages
  alias Pamela.Telegram
  alias Pamela.Command.Trade.Coins
  alias Pamela.Trading

  def run(command, user) do
    case Nadia.send_message(user.id, Messages.trade_intro()) do
      {:ok, _success} ->
        Telegram.create_command_message(command.message_id, "trade_intro")

      {:error, error} ->
        {:error, error}
    end
  end

  def handle(command, message, user) do
    case Trading.create_session(%{
           name: message.text,
           telegram_user_id: user.id,
           running: true,
           command_id: command.message_id
         }) do
      {:ok, _sess} -> Coins.run(command, user)
      error -> error
    end
  end
end
