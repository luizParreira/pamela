defmodule Pamela.Command.Trade do
  alias Pamela.Command.TelegramCommandMessage
  alias Pamela.Command.Messages
  alias Pamela.Command
  alias Pamela.Trading

  def run(command, message, user) do
    case Command.get_telegram_command_message_by(command.update_id) do
      [] -> run_intro(command, message, user)
      [command_msg] -> run(command_msg.message, command, message, user)
      [command_msg | _commands] -> run(command_msg.message, command, message, user)
    end
  end

  defp run_intro(command, message, user) do
    case Nadia.send_message(user.id, Messages.trade_intro()) do
      {:ok, success} -> create_command_message(command.update_id, "trade_intro")
      {:error, error} -> {:error, error}
    end
  end

  defp create_command_message(id, message) do
    Command.create_telegram_command_message(%{
      telegram_command_update_id: id,
      message: message
    })
  end

  defp run("trade_intro", command, message, user) do
    case Trading.create_session(%{name: message.text, telegram_user_id: user.id, running: true}) do
      {:ok, sess} -> run_coins(command, user)
      error -> error
    end
  end

  defp run_coins(command, user) do
    case Nadia.send_message(user.id, Messages.coins()) do
      {:ok, _message} -> create_command_message(command.update_id, "trade_coins")
      result -> result
    end
  end

  defp run("trade_coins", command, message, user) do
    case String.split(message.text, ",") do
      [] -> {:error, :unknown_coins}
      [coin] -> {:error, :only_one_coin}
      [base |  coins] -> get_trading_session(base, coins, user, command)
    end
  end

  defp get_trading_session(base, coins, user, command) do
    case Trading.get_session_by(user.id, true) do
      [] -> {:error, :need_session_to_save_coins}
      [session] -> create_base_coin(session.id, base, coins, command, user)
    end
  end

  defp create_base_coin(id, base, coins, command, user) do
    case Trading.create_coin(%{symbol: base, base: true, session_id: id}) do
      {:ok, coin} -> create_coins(id, command, user, coins)
      error -> error
    end
  end

  defp create_coins(id, command, user, []), do: run_period(id, command, user)
  defp create_coins(id, command, user, [coin | coins]) do
    Trading.create_coin(%{symbol: coin, session_id: id})
    create_coins(id, command, user, coins)
  end


  defp run_period(session_id, command, user) do
    {coins, trading_pairs} = formatted_coins(session_id)
    case Nadia.send_message(user.id, Messages.period(coins, trading_pairs)) do
      {:ok, _msg} -> create_command_message(command.update_id, "trade_period")
      error -> error
    end
  end

  defp run("trade_period", command, message, user) do
    case Trading.get_session_by(user.id, true) do
      [] -> {:error, :no_session_started}
      [session] -> parse_period(command, message, user, session)
      sessions -> {:error, :only_one_session_allowed}
    end
  end

  defp parse_period(command, message, user, session) do
    case Float.parse(message.text) do
      {_val, _rem} -> save_trading_period(session, command, message, user)
      :error -> Nadia.send_message(user.id, "This is not a number. Please send a number in hours.")
    end
  end

  defp save_trading_period(session, command, message, user) do
    case Trading.create_period(%{session_id: session.id, period: message.text}) do
      {:ok, period} -> run_confirmation(session, command, message, user, period)
      error -> error
    end
  end

  defp run_confirmation(session, command, message, user, period) do
    {coins, trading_pairs} = formatted_coins(session.id)
    case Nadia.send_message(user.id, Messages.confirm_session(coins, trading_pairs, period.period)) do
      {:ok, _msg} -> create_command_message(command.update_id, "trade_confirmation")
      error -> error
    end
  end

  defp run("trade_confirmation", command, message, user) do
    case String.downcase(message.text) do
      "yes" -> run_positive_confirmation(command, message, user)
      "no" -> run_negative_confirmation(command, message, user)
      _ -> Nadia.send_message(user.id, "Please respond with yes or no")
    end
  end

  defp run_positive_confirmation(command, message, user) do
    #TODO: This is where we shal initiate the action to trade
    case Pamela.Command.update_telegram_command(command, %{executed: true}) do
      {:ok, _cmd} -> Nadia.send_message(user.id, "Command #{command.command} executed!")
      error -> error
    end
  end

  defp run_negative_confirmation(command, message, user) do
    case Pamela.Command.update_telegram_command(command, %{executed: true}) do
      {:ok, _cmd} -> update_session(user)
      error -> error
    end
  end

  defp update_session(user) do
    [session] = Trading.get_session_by(user.id, true)
    Trading.update_session(session, %{running: false})
  end

  defp formatted_coins(session_id) do
    coins = Trading.get_coin_by(session_id)
    IO.inspect coins
    base = Enum.filter(coins, fn coin -> coin.base end)
    trading_coins = Enum.filter(coins, fn coin -> !coin.base end)

    symbols = Enum.map(coins, fn coin -> coin.symbol end)
    trading_pairs = Enum.map(coins, fn coin ->
      if !coin.base do
        coin.symbol <> base.symbol
      else
        coin.symbol
      end
    end)
    {symbols, trading_pairs}
  end
end
