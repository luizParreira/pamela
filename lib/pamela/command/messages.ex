defmodule Pamela.Command.Messages do
  def intro(user) do
    """
    Hello #{user.first_name}!

    I am Pamela, I like trading cryptocurrencies..🚀

    Here are the list of commands I currently support:

    💸 /trade - Start trading session. Or, do nothing if already trading.
    ✋ /halt - Stop the current trading session. Or, do othing if not tradig.
    """
  end

  def trade_intro do
    """
    Ok, we are ready to roll.

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

  def existing_session(session) do
    """
    You already have #{session.name} going!

    Please, run /halt to stop it!
    """
  end

  def no_session do
    "You have no trading session created, please run /trade, in order to start"
  end

  def session_halted(session) do
    """
    Stoping session #{session.name}, now!

    See you laterr😎
    """
  end
end
