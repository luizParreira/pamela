defmodule Pamela.Trader.SessionReport do
  def report(base, session, target, balances, allocation, total) do
    message = """
    Target:
    #{format_coins(target)}

    Balances:
    #{format_coins(balances)}

    Allocation:
    #{format_coins(allocation)}

    Total Base #{base.symbol} Value:
    #{total} #{base.symbol}
    """

    Nadia.send_message(session.telegram_user_id, message)
  end

  defp format_coins(coins) do
    coins
    |> Enum.map(fn {coin, balance} -> "#{coin} 💰  #{balance}\n" end)
    |> Enum.join()
  end
end
