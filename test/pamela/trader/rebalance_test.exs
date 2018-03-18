defmodule Pamela.Trader.RebalanceTest do
  use Pamela.DataCase
  alias Pamela.Trader
  alias Pamela.User
  alias Pamela.Telegram
  alias Pamela.Trading

  describe "rebalance/1" do
    @user_attrs %{id: 1, first_name: "Jose", username: "zeh_trader"}
    @mesage_attrs %{update_id: 9999, text: "/trade", type: "command", user_id: 1}
    @command_attrs %{message_id: 9999, command: "/trade", telegram_user_id: 1, executed: true}
    @session_attrs %{name: "Zé Bolivia", running: true, telegram_user_id: 1, command_id: 9999}
    @coins_attrs [
      %{symbol: "BTC", base: true, session_id: nil},
      %{symbol: "XLM", base: false, session_id: nil},
      %{symbol: "ADA", base: false, session_id: nil},
      %{symbol: "XRP", base: false, session_id: nil}
    ]
    @period_attrs %{period: "3", session_id: nil}

    def create_coins(session) do
      {:ok,
       Enum.map(@coins_attrs, fn attrs ->
         case Trading.create_coin(%{attrs | session_id: session.id}) do
           {:ok, coin} -> coin
           _error -> _error
         end
       end)}
    end

    def init_rebalance_fixture() do
      with {:ok, user} <- User.create_telegram_user(@user_attrs),
           {:ok, msg} <- Telegram.create_message(@mesage_attrs),
           {:ok, command} <- Telegram.create_command(@command_attrs),
           {:ok, session} <- Trading.create_session(@session_attrs),
           {:ok, coins} <- create_coins(session),
           {:ok, period} <- Trading.create_period(%{@period_attrs | session_id: session.id}) do
        {:ok, session, period, coins}
      end
    end

    test "user starts a rebalancing on the initial state" do
      {:ok, session, period, coins} = init_rebalance_fixture()
      now = DateTime.utc_now()
      {:ok, _msg} = Trader.rebalance(state: :init, now: now)

      transactions = Trading.get_rebalance_transactions_by(session_id: session.id)
      [transaction] = transactions
      trades = Trading.get_trades_by(transaction_id: transaction.id)
      assert Enum.count(transactions) === 1
      assert Enum.count(trades) === 3
    end

    def update_rebalance_fixture() do
      {:ok, session, period, coins} = init_rebalance_fixture()
      now = DateTime.utc_now()
      {:ok, _msg} = Trader.rebalance(state: :init, now: now)
      {:ok, session, period, coins, now}
    end

    test "user starts a rebalancing on the update state" do
      {:ok, session, period, coins, now} = update_rebalance_fixture()
      new_now = Timex.shift(now, hours: 3, minutes: 1)

      {:ok, _msg} = Trader.rebalance(state: :update, now: new_now)

      transactions = Trading.get_rebalance_transactions_by(session_id: session.id)
      [transaction1, transaction2] = transactions
      trades1 = Trading.get_trades_by(transaction_id: transaction1.id)
      trades2 = Trading.get_trades_by(transaction_id: transaction2.id)
      assert Enum.count(transactions) === 2
      assert Enum.count(trades1) === 3
      assert Enum.count(trades2) === 3
    end
  end
end
