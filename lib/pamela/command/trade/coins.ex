defmodule Pamela.Command.Trade.Coins do
  alias Pamela.Telegram
  alias Pamela.Command.Trade.Period
  alias Pamela.Command.Messages
  alias Pamela.Trading

  def run(command, user) do
    case Nadia.send_message(user.id, Messages.coins()) do
      {:ok, _message} ->
        Telegram.create_command_message(command.message_id, "trade_coins")

      result ->
        result
    end
  end

  def handle(command, message, user) do
    case String.split(message.text, ",") do
      [] -> {:error, :unknown_coins}
      [_coin] -> {:error, :only_one_coin}
      [base | coins] -> get_trading_session(base, coins, user, command)
    end
  end

  defp get_trading_session(base, coins, user, command) do
    case Trading.get_session_by(user.id, true) do
      [] -> {:error, :need_session_to_save_coins}
      [session] -> create_base_coin(session.id, base, coins, command, user)
    end
  end

  defp create_base_coin(id, base, coins, command, user) do
    case Trading.create_coin(%{symbol: String.trim(base), base: true, session_id: id}) do
      {:ok, _coin} -> create_coins(id, command, user, coins)
      error -> error
    end
  end

  defp create_coins(id, command, user, []), do: Period.run(id, command, user)

  defp create_coins(id, command, user, [coin | coins]) do
    Trading.create_coin(%{symbol: String.trim(coin), session_id: id})
    create_coins(id, command, user, coins)
  end
end
