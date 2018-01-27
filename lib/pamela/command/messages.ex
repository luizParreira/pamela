defmodule Pamela.Command.Messages do
  def intro(user) do
    """
    Hello #{user.first_name}!

    I am Pamela, I like trading cryptocurrencies..🚀

    Here are the list of commands I currently support:

    💸 /trade - Start trading session. 1 - set name. 2 - set coins. 3 - set period. 4 - confirm
    ✋ /halt - Stop the current trading session. Or, do othing if not tradin.
    """
  end

  def trade_intro do
    """
    Ok, are ready to roll.

    First, what is the name this trading session?

    Ex. Bolivia
    """
  end

  def coins do
    """
    💰💰💰
    Please, tell me the coins you want to trade. Separate them by comma, starting from the base coin.

    Ps. Make sure you **always** send the basecoin first.

    Ex. BTC, ETH, XLM, ADA
    =>  BTC, ETHBTC, XLMBTC, ADABTC
    """
  end

  def period(coins, trading_pairs) do
    """
    ⏳⏳⏳
    We have saved your coins:

    Coins:
    #{Enum.join(coins, ", ")}

    Trading Pairs:
    #{Enum.join(trading_pairs, ", ")}

    Now, you have to tell us how often the trading will be going on in hours.

    Ex. 6
    => Every 6 hours
    """
  end

  def confirm_session(coins, trading_pairs, period) do
    """
    🚀🚀🚀
    Thats great, we are ready to start trading like a boss.

    Lets just confirm what we just did:

    Coins:
    #{Enum.join(coins, ", ")}

    Trading Pairs:
    #{Enum.join(trading_pairs, ", ")}

    Period:
    Every #{period} hours.

    Can I start trading with the above information?
    yes or no
    """
  end
end
