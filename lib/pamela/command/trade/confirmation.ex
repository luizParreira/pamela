defmodule Pamela.Command.Trade.Confirmation do
  alias Pamela.Telegram
  alias Pamela.Command.Messages
  alias Pamela.Trading
  alias Pamela.Trading.FormatCoins

  def run(session, command, user, period) do
    {coins, trading_pairs} = formatted_coins(session.id)

    case Nadia.send_message(
           user.id,
           Messages.confirm_session(coins, trading_pairs, period.period)
         ) do
      {:ok, _msg} ->
        Telegram.create_command_message(command.message_id, "trade_confirmation")

      error ->
        error
    end
  end

  def handle(command, message, user) do
    case String.downcase(message.text) do
      "yes" -> run_positive_confirmation(command, user)
      "no" -> run_negative_confirmation(command, user)
      _ -> {:error, :invalid_response}
    end
  end

  defp run_positive_confirmation(command, _user) do
    case Telegram.update_command(command, %{executed: true}) do
      {:ok, _cmd} ->
        Pamela.Trader.rebalance(state: :init, now: DateTime.utc_now())

      error ->
        error
    end
  end

  defp run_negative_confirmation(command, user) do
    case Telegram.update_command(command, %{executed: true}) do
      {:ok, _cmd} -> update_session(user)
      error -> error
    end
  end

  defp update_session(user) do
    [session] = Trading.get_session_by(user.id, true)
    Trading.update_session(session, %{running: false})
  end

  defp formatted_coins(session_id) do
    session_id
    |> Trading.get_coins_by()
    |> FormatCoins.format()
  end
end
