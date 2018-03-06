defmodule Pamela.TradingTest do
  use Pamela.DataCase

  alias Pamela.Trading

  describe "trading_sessions" do
    alias Pamela.Trading.Session

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def session_fixture(attrs \\ %{}) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trading.create_session()

      session
    end

    test "list_trading_sessions/0 returns all trading_sessions" do
      session = session_fixture()
      assert Trading.list_trading_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Trading.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, %Session{} = session} = Trading.create_session(@valid_attrs)
      assert session.name == "some name"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      assert {:ok, session} = Trading.update_session(session, @update_attrs)
      assert %Session{} = session
      assert session.name == "some updated name"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Trading.update_session(session, @invalid_attrs)
      assert session == Trading.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Trading.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Trading.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Trading.change_session(session)
    end
  end

  describe "trading_coins" do
    alias Pamela.Trading.Coin

    @valid_attrs %{base: true, session_id: 42, symbol: "some symbol"}
    @update_attrs %{base: false, session_id: 43, symbol: "some updated symbol"}
    @invalid_attrs %{base: nil, session_id: nil, symbol: nil}

    def coin_fixture(attrs \\ %{}) do
      {:ok, coin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trading.create_coin()

      coin
    end

    test "list_trading_coins/0 returns all trading_coins" do
      coin = coin_fixture()
      assert Trading.list_trading_coins() == [coin]
    end

    test "get_coin!/1 returns the coin with given id" do
      coin = coin_fixture()
      assert Trading.get_coin!(coin.id) == coin
    end

    test "create_coin/1 with valid data creates a coin" do
      assert {:ok, %Coin{} = coin} = Trading.create_coin(@valid_attrs)
      assert coin.base == true
      assert coin.session_id == 42
      assert coin.symbol == "some symbol"
    end

    test "create_coin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_coin(@invalid_attrs)
    end

    test "update_coin/2 with valid data updates the coin" do
      coin = coin_fixture()
      assert {:ok, coin} = Trading.update_coin(coin, @update_attrs)
      assert %Coin{} = coin
      assert coin.base == false
      assert coin.session_id == 43
      assert coin.symbol == "some updated symbol"
    end

    test "update_coin/2 with invalid data returns error changeset" do
      coin = coin_fixture()
      assert {:error, %Ecto.Changeset{}} = Trading.update_coin(coin, @invalid_attrs)
      assert coin == Trading.get_coin!(coin.id)
    end

    test "delete_coin/1 deletes the coin" do
      coin = coin_fixture()
      assert {:ok, %Coin{}} = Trading.delete_coin(coin)
      assert_raise Ecto.NoResultsError, fn -> Trading.get_coin!(coin.id) end
    end

    test "change_coin/1 returns a coin changeset" do
      coin = coin_fixture()
      assert %Ecto.Changeset{} = Trading.change_coin(coin)
    end
  end

  describe "trading_periods" do
    alias Pamela.Trading.Period

    @valid_attrs %{period: "some period", session_id: 42}
    @update_attrs %{period: "some updated period", session_id: 43}
    @invalid_attrs %{period: nil, session_id: nil}

    def period_fixture(attrs \\ %{}) do
      {:ok, period} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trading.create_period()

      period
    end

    test "list_trading_periods/0 returns all trading_periods" do
      period = period_fixture()
      assert Trading.list_trading_periods() == [period]
    end

    test "get_period!/1 returns the period with given id" do
      period = period_fixture()
      assert Trading.get_period!(period.id) == period
    end

    test "create_period/1 with valid data creates a period" do
      assert {:ok, %Period{} = period} = Trading.create_period(@valid_attrs)
      assert period.period == "some period"
      assert period.session_id == 42
    end

    test "create_period/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_period(@invalid_attrs)
    end

    test "update_period/2 with valid data updates the period" do
      period = period_fixture()
      assert {:ok, period} = Trading.update_period(period, @update_attrs)
      assert %Period{} = period
      assert period.period == "some updated period"
      assert period.session_id == 43
    end

    test "update_period/2 with invalid data returns error changeset" do
      period = period_fixture()
      assert {:error, %Ecto.Changeset{}} = Trading.update_period(period, @invalid_attrs)
      assert period == Trading.get_period!(period.id)
    end

    test "delete_period/1 deletes the period" do
      period = period_fixture()
      assert {:ok, %Period{}} = Trading.delete_period(period)
      assert_raise Ecto.NoResultsError, fn -> Trading.get_period!(period.id) end
    end

    test "change_period/1 returns a period changeset" do
      period = period_fixture()
      assert %Ecto.Changeset{} = Trading.change_period(period)
    end
  end

  describe "trading_trades" do
    alias Pamela.Trading.Trade

    @valid_attrs %{amount: "some amount", base: "some base", coin: "some coin", price: "some price", rebalance_transaction_id: 42, side: "some side"}
    @update_attrs %{amount: "some updated amount", base: "some updated base", coin: "some updated coin", price: "some updated price", rebalance_transaction_id: 43, side: "some updated side"}
    @invalid_attrs %{amount: nil, base: nil, coin: nil, price: nil, rebalance_transaction_id: nil, side: nil}

    def trade_fixture(attrs \\ %{}) do
      {:ok, trade} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trading.create_trade()

      trade
    end

    test "list_trading_trades/0 returns all trading_trades" do
      trade = trade_fixture()
      assert Trading.list_trading_trades() == [trade]
    end

    test "get_trade!/1 returns the trade with given id" do
      trade = trade_fixture()
      assert Trading.get_trade!(trade.id) == trade
    end

    test "create_trade/1 with valid data creates a trade" do
      assert {:ok, %Trade{} = trade} = Trading.create_trade(@valid_attrs)
      assert trade.amount == "some amount"
      assert trade.base == "some base"
      assert trade.coin == "some coin"
      assert trade.price == "some price"
      assert trade.rebalance_transaction_id == 42
      assert trade.side == "some side"
    end

    test "create_trade/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_trade(@invalid_attrs)
    end

    test "update_trade/2 with valid data updates the trade" do
      trade = trade_fixture()
      assert {:ok, trade} = Trading.update_trade(trade, @update_attrs)
      assert %Trade{} = trade
      assert trade.amount == "some updated amount"
      assert trade.base == "some updated base"
      assert trade.coin == "some updated coin"
      assert trade.price == "some updated price"
      assert trade.rebalance_transaction_id == 43
      assert trade.side == "some updated side"
    end

    test "update_trade/2 with invalid data returns error changeset" do
      trade = trade_fixture()
      assert {:error, %Ecto.Changeset{}} = Trading.update_trade(trade, @invalid_attrs)
      assert trade == Trading.get_trade!(trade.id)
    end

    test "delete_trade/1 deletes the trade" do
      trade = trade_fixture()
      assert {:ok, %Trade{}} = Trading.delete_trade(trade)
      assert_raise Ecto.NoResultsError, fn -> Trading.get_trade!(trade.id) end
    end

    test "change_trade/1 returns a trade changeset" do
      trade = trade_fixture()
      assert %Ecto.Changeset{} = Trading.change_trade(trade)
    end
  end

  describe "trading_rebalance_transactions" do
    alias Pamela.Trading.RebalanceTransaction

    @valid_attrs %{session_id: 42, time: 42}
    @update_attrs %{session_id: 43, time: 43}
    @invalid_attrs %{session_id: nil, time: nil}

    def rebalance_transaction_fixture(attrs \\ %{}) do
      {:ok, rebalance_transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trading.create_rebalance_transaction()

      rebalance_transaction
    end

    test "list_trading_rebalance_transactions/0 returns all trading_rebalance_transactions" do
      rebalance_transaction = rebalance_transaction_fixture()
      assert Trading.list_trading_rebalance_transactions() == [rebalance_transaction]
    end

    test "get_rebalance_transaction!/1 returns the rebalance_transaction with given id" do
      rebalance_transaction = rebalance_transaction_fixture()
      assert Trading.get_rebalance_transaction!(rebalance_transaction.id) == rebalance_transaction
    end

    test "create_rebalance_transaction/1 with valid data creates a rebalance_transaction" do
      assert {:ok, %RebalanceTransaction{} = rebalance_transaction} = Trading.create_rebalance_transaction(@valid_attrs)
      assert rebalance_transaction.session_id == 42
      assert rebalance_transaction.time == 42
    end

    test "create_rebalance_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_rebalance_transaction(@invalid_attrs)
    end

    test "update_rebalance_transaction/2 with valid data updates the rebalance_transaction" do
      rebalance_transaction = rebalance_transaction_fixture()
      assert {:ok, rebalance_transaction} = Trading.update_rebalance_transaction(rebalance_transaction, @update_attrs)
      assert %RebalanceTransaction{} = rebalance_transaction
      assert rebalance_transaction.session_id == 43
      assert rebalance_transaction.time == 43
    end

    test "update_rebalance_transaction/2 with invalid data returns error changeset" do
      rebalance_transaction = rebalance_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Trading.update_rebalance_transaction(rebalance_transaction, @invalid_attrs)
      assert rebalance_transaction == Trading.get_rebalance_transaction!(rebalance_transaction.id)
    end

    test "delete_rebalance_transaction/1 deletes the rebalance_transaction" do
      rebalance_transaction = rebalance_transaction_fixture()
      assert {:ok, %RebalanceTransaction{}} = Trading.delete_rebalance_transaction(rebalance_transaction)
      assert_raise Ecto.NoResultsError, fn -> Trading.get_rebalance_transaction!(rebalance_transaction.id) end
    end

    test "change_rebalance_transaction/1 returns a rebalance_transaction changeset" do
      rebalance_transaction = rebalance_transaction_fixture()
      assert %Ecto.Changeset{} = Trading.change_rebalance_transaction(rebalance_transaction)
    end
  end
end
