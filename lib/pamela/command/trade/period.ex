defmodule Pamela.Command.Trade.Period do
  alias Pamela.Command.Messages
  alias Pamela.Trading
  alias Pamela.Telegram
  alias Pamela.Command.Trade.Confirmation
  alias Trading.{FormatCoins}

  def run(id, command, user) do
    {coins, trading_pairs} = formatted_coins(id)

    case Nadia.send_message(user.id, Messages.period(coins, trading_pairs)) do
      {:ok, _msg} ->
        Telegram.create_command_message(command.message_id, "trade_period")

      error ->
        error
    end
  end

  def handle(command, message, user) do
    case Trading.get_session_by(user.id, true) do
      [] -> {:error, :no_session_started}
      [session] -> parse_period(command, message, user, session)
      _sessions -> {:error, :only_one_session_allowed}
    end
  end

  defp parse_period(command, message, user, session) do
    case Float.parse(message.text) do
      {_val, _rem} -> save_trading_period(session, command, message, user)
      :error -> {:error, :not_number}
    end
  end

  defp save_trading_period(session, command, message, user) do
    case Trading.create_period(%{session_id: session.id, period: message.text}) do
      {:ok, period} -> Confirmation.run(session, command, user, period)
      error -> error
    end
  end

  defp formatted_coins(session_id) do
    session_id
    |> Trading.get_coins_by()
    |> FormatCoins.format()
  end
end
