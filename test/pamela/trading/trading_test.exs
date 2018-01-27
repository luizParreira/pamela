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
end
