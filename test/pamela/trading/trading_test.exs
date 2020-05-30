defmodule Pamela.TradingTest do
  use Pamela.DataCase

  alias Pamela.Trading
  alias Pamela.User
  alias Pamela.Telegram
  @command_valid_attrs %{command: "/trade", telegram_user_id: 42, message_id: 99, executed: false}

  def fixture() do
    {:ok, user} = User.create_telegram_user(%{username: "zezinho", id: 10})

    {:ok, message} =
      Telegram.create_message(%{
        update_id: :rand.uniform(1_000_000_000),
        text: "/trade",
        type: "command",
        user_id: user.id
      })

    {:ok, command} =
      Telegram.create_command(%{
        @command_valid_attrs
        | message_id: message.update_id,
          telegram_user_id: user.id
      })

    {user, command}
  end

  def session_fixture() do
    {user, command} = fixture()
    session_attrs = %{name: "some name", running: false, telegram_user_id: nil, command_id: nil}

    {:ok, session} =
      Trading.create_session(%{
        session_attrs
        | telegram_user_id: user.id,
          command_id: command.message_id
      })

    {session, user, command}
  end

  def rebalance_transaction_fixture() do
    {session, _user, _command} = session_fixture()

    {:ok, rebalance_transaction} =
      Trading.create_rebalance_transaction(%{
        session_id: session.id,
        time: DateTime.utc_now()
      })

    {rebalance_transaction, session}
  end

  describe "trading_sessions" do
    alias Pamela.Trading.Session

    @update_attrs %{
      name: "some updated name",
      running: true
    }
    @invalid_attrs %{name: nil}

    test "get_session_by/2 returns the session with given user id" do
      {session, user, _command} = session_fixture()
      assert Trading.get_session_by(user.id, false) == [session]
    end

    test "create_session/1 with valid data creates a session" do
      {session, _user, _command} = session_fixture()
      assert %Session{} = created_session = session
      assert created_session.name == "some name"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      {session, _user, _command} = session_fixture()
      assert {:ok, session} = Trading.update_session(session, @update_attrs)
      assert %Session{} = session
      assert session.name == "some updated name"
      assert session.running == true
    end

    test "update_session/2 with invalid data returns error changeset" do
      {session, user, _command} = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Trading.update_session(session, @invalid_attrs)
      assert [session] == Trading.get_session_by(user.id, false)
    end
  end

  describe "trading_coins" do
    alias Pamela.Trading.Coin

    @valid_attrs %{base: true, session_id: 42, symbol: "some symbol"}
    @invalid_attrs %{base: nil, session_id: nil, symbol: nil}

    def coin_fixture(attrs \\ %{}) do
      {session, _, _} = session_fixture()

      {:ok, coin} =
        attrs
        |> Enum.into(%{@valid_attrs | session_id: session.id})
        |> Trading.create_coin()

      {coin, session}
    end

    test "get_coins_by/1 returns the coin with given session id" do
      {coin, session} = coin_fixture()
      assert Trading.get_coins_by(session.id) == [coin]
      assert Trading.get_coins_by(session_id: session.id) == [coin]
    end

    test "create_coin/1 with valid data creates a coin" do
      assert {%Coin{} = coin, session} = coin_fixture()
      assert coin.base == true
      assert coin.session_id == session.id
      assert coin.symbol == "some symbol"
    end

    test "create_coin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_coin(@invalid_attrs)
    end
  end

  describe "trading_periods" do
    alias Pamela.Trading.Period

    @valid_attrs %{period: "some period", session_id: nil}
    @invalid_attrs %{period: nil, session_id: nil}

    def period_fixture(attrs \\ %{}) do
      {session, _user, _command} = session_fixture()

      {:ok, period} =
        attrs
        |> Enum.into(%{@valid_attrs | session_id: session.id})
        |> Trading.create_period()

      {period, session}
    end

    test "get_period_by/1 returns the period with given session id" do
      {period, session} = period_fixture()
      assert Trading.get_period_by(session: session) == period
    end

    test "create_period/1 with valid data creates a period" do
      assert {%Period{} = period, session} = period_fixture()

      assert period.period == "some period"
      assert period.session_id == session.id
    end

    test "create_period/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_period(@invalid_attrs)
    end
  end

  describe "trading_trades" do
    alias Pamela.Trading.Trade

    @valid_attrs %{
      amount: "some amount",
      base: "some base",
      coin: "some coin",
      price: "some price",
      rebalance_transaction_id: nil,
      side: "some side",
      time: DateTime.utc_now()
    }
    @invalid_attrs %{
      amount: nil,
      base: nil,
      coin: nil,
      price: nil,
      rebalance_transaction_id: nil,
      side: nil
    }

    def trade_fixture(attrs \\ %{}) do
      {transaction, _} = rebalance_transaction_fixture()

      {:ok, trade} =
        attrs
        |> Enum.into(%{@valid_attrs | rebalance_transaction_id: transaction.id})
        |> Trading.create_trade()

      {trade, transaction}
    end

    test "get_trades_by/1 returns the trade with given id" do
      {trade, transaction} = trade_fixture()
      assert Trading.get_trades_by(transaction_id: transaction.id) == [trade]
    end

    test "create_trade/1 with valid data creates a trade" do
      {trade, transaction} = trade_fixture()
      assert %Trade{} = created_trade = trade
      assert created_trade.amount == "some amount"
      assert created_trade.base == "some base"
      assert created_trade.coin == "some coin"
      assert created_trade.price == "some price"
      assert created_trade.rebalance_transaction_id == transaction.id
      assert created_trade.side == "some side"
    end

    test "create_trade/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_trade(@invalid_attrs)
    end
  end

  describe "trading_rebalance_transactions" do
    alias Pamela.Trading.RebalanceTransaction
    @invalid_attrs %{session_id: nil, time: nil}

    test "get_rebalance_transactions_by/1 returns the rebalance_transaction with given session id" do
      {rebalance_transaction, session} = rebalance_transaction_fixture()

      assert Trading.get_rebalance_transactions_by(session_id: session.id) == [
               rebalance_transaction
             ]
    end

    test "create_rebalance_transaction/1 with valid data creates a rebalance_transaction" do
      {session, _user, _command} = session_fixture()

      assert {:ok, %RebalanceTransaction{} = rebalance_transaction} =
               Trading.create_rebalance_transaction(%{
                 time: DateTime.utc_now(),
                 session_id: session.id
               })

      assert rebalance_transaction.session_id == session.id
    end

    test "create_rebalance_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_rebalance_transaction(@invalid_attrs)
    end
  end

  describe "trading_balances" do
    alias Pamela.Trading.Balance

    @valid_attrs %{balance: 120.5, coin: "some coin", rebalance_transaction_id: 42}
    @invalid_attrs %{balance: nil, coin: nil, rebalance_transaction_id: nil}

    def balance_fixture(attrs \\ %{}) do
      {:ok, balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trading.create_balance()

      balance
    end

    test "create_balance/1 with valid data creates a balance" do
      {transaction, _} = rebalance_transaction_fixture()

      assert {:ok, %Balance{} = balance} =
               Trading.create_balance(%{@valid_attrs | rebalance_transaction_id: transaction.id})

      assert balance.balance == 120.5
      assert balance.coin == "some coin"
      assert balance.rebalance_transaction_id == transaction.id
    end

    test "create_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_balance(@invalid_attrs)
    end
  end
end
