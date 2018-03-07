defmodule Pamela.Trading do
  @moduledoc """
  The Trading context.
  """

  import Ecto.Query, warn: false
  alias Pamela.Repo

  alias Pamela.Trading.Session

  @doc """
  Returns the list of trading_sessions.

  ## Examples

      iex> list_trading_sessions()
      [%Session{}, ...]

  """
  def list_trading_sessions do
    Repo.all(Session)
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_session(123)
      %Session{}

      iex> get_session(456)
      nil

  """
  def get_session(id), do: Repo.get(Session, id)

  def get_session_by(telegram_user_id, running) do
    Repo.all(
      from(
        s in Session,
        where: s.telegram_user_id == ^telegram_user_id and s.running == ^running,
        select: s
      )
    )
  end

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, %{field: new_value})
      {:ok, %Session{}}

      iex> update_session(session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

      iex> delete_session(session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{source: %Session{}}

  """
  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end

  alias Pamela.Trading.Coin

  @doc """
  Returns the list of trading_coins.

  ## Examples

      iex> list_trading_coins()
      [%Coin{}, ...]

  """
  def list_trading_coins do
    Repo.all(Coin)
  end

  @doc """
  Gets a single coin.

  Raises `Ecto.NoResultsError` if the Coin does not exist.

  ## Examples

      iex> get_coin!(123)
      %Coin{}

      iex> get_coin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coin!(id), do: Repo.get!(Coin, id)

  def get_coins_by(session_id: session_id) do
    Repo.all(
      from(
        s in Coin,
        where: s.session_id == ^session_id,
        select: s
      )
    )
  end

  def get_coins_by(session_id), do: get_coins_by(session_id: session_id)

  @doc """
  Creates a coin.

  ## Examples

      iex> create_coin(%{field: value})
      {:ok, %Coin{}}

      iex> create_coin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coin(attrs \\ %{}) do
    %Coin{}
    |> Coin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coin.

  ## Examples

      iex> update_coin(coin, %{field: new_value})
      {:ok, %Coin{}}

      iex> update_coin(coin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coin(%Coin{} = coin, attrs) do
    coin
    |> Coin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Coin.

  ## Examples

      iex> delete_coin(coin)
      {:ok, %Coin{}}

      iex> delete_coin(coin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coin(%Coin{} = coin) do
    Repo.delete(coin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coin changes.

  ## Examples

      iex> change_coin(coin)
      %Ecto.Changeset{source: %Coin{}}

  """
  def change_coin(%Coin{} = coin) do
    Coin.changeset(coin, %{})
  end

  alias Pamela.Trading.Period

  @doc """
  Returns the list of trading_periods.

  ## Examples

      iex> list_trading_periods()
      [%Period{}, ...]

  """
  def list_trading_periods do
    Repo.all(Period)
  end

  @doc """
  Gets a single period.

  Raises `nil` if the Period does not exist.

  ## Examples

      iex> get_period(123)
      %Period{}

      iex> get_period(456)
      ** nil

  """
  def get_period(id), do: Repo.get(Period, id)

  def get_period_by(session: session) do
    Repo.get_by(Period, session_id: session.id)
  end

  @doc """
  Creates a period.

  ## Examples

      iex> create_period(%{field: value})
      {:ok, %Period{}}

      iex> create_period(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_period(attrs \\ %{}) do
    %Period{}
    |> Period.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a period.

  ## Examples

      iex> update_period(period, %{field: new_value})
      {:ok, %Period{}}

      iex> update_period(period, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_period(%Period{} = period, attrs) do
    period
    |> Period.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Period.

  ## Examples

      iex> delete_period(period)
      {:ok, %Period{}}

      iex> delete_period(period)
      {:error, %Ecto.Changeset{}}

  """
  def delete_period(%Period{} = period) do
    Repo.delete(period)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking period changes.

  ## Examples

      iex> change_period(period)
      %Ecto.Changeset{source: %Period{}}

  """
  def change_period(%Period{} = period) do
    Period.changeset(period, %{})
  end

  alias Pamela.Trading.Trade

  @doc """
  Returns the list of trading_trades.

  ## Examples

      iex> list_trading_trades()
      [%Trade{}, ...]

  """
  def list_trading_trades do
    Repo.all(Trade)
  end

  @doc """
  Gets a single trade.

  Raises `Ecto.NoResultsError` if the Trade does not exist.

  ## Examples

      iex> get_trade!(123)
      %Trade{}

      iex> get_trade!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trade!(id), do: Repo.get!(Trade, id)

  @doc """
  Creates a trade.

  ## Examples

      iex> create_trade(%{field: value})
      {:ok, %Trade{}}

      iex> create_trade(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trade(attrs \\ %{}) do
    %Trade{}
    |> Trade.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trade.

  ## Examples

      iex> update_trade(trade, %{field: new_value})
      {:ok, %Trade{}}

      iex> update_trade(trade, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trade(%Trade{} = trade, attrs) do
    trade
    |> Trade.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Trade.

  ## Examples

      iex> delete_trade(trade)
      {:ok, %Trade{}}

      iex> delete_trade(trade)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trade(%Trade{} = trade) do
    Repo.delete(trade)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trade changes.

  ## Examples

      iex> change_trade(trade)
      %Ecto.Changeset{source: %Trade{}}

  """
  def change_trade(%Trade{} = trade) do
    Trade.changeset(trade, %{})
  end

  alias Pamela.Trading.RebalanceTransaction

  @doc """
  Returns the list of trading_rebalance_transactions.

  ## Examples

      iex> list_trading_rebalance_transactions()
      [%RebalanceTransaction{}, ...]

  """
  def list_trading_rebalance_transactions do
    Repo.all(RebalanceTransaction)
  end

  @doc """
  Gets a single rebalance_transaction.

  Raises `Ecto.NoResultsError` if the Rebalance transaction does not exist.

  ## Examples

      iex> get_rebalance_transaction!(123)
      %RebalanceTransaction{}

      iex> get_rebalance_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rebalance_transaction!(id), do: Repo.get!(RebalanceTransaction, id)

  def fetch_latest_transaction(%Session{id: id}) do
    transaction =
      Repo.one(
        from(transaction in RebalanceTransaction, order_by: [desc: transaction.time], limit: 1)
      )

    {:ok, transaction}
  end

  defp resolve_transaction(nil, id) do
    attrs = %{session_id: id, time: DateTime.utc_now()}
    create_rebalance_transaction(attrs)
  end

  defp resolve_transaction(transaction, _id) do
    {:ok, transaction}
  end

  @doc """
  Creates a rebalance_transaction.

  ## Examples

      iex> create_rebalance_transaction(%{field: value})
      {:ok, %RebalanceTransaction{}}

      iex> create_rebalance_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rebalance_transaction(attrs \\ %{}) do
    %RebalanceTransaction{}
    |> RebalanceTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rebalance_transaction.

  ## Examples

      iex> update_rebalance_transaction(rebalance_transaction, %{field: new_value})
      {:ok, %RebalanceTransaction{}}

      iex> update_rebalance_transaction(rebalance_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rebalance_transaction(%RebalanceTransaction{} = rebalance_transaction, attrs) do
    rebalance_transaction
    |> RebalanceTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a RebalanceTransaction.

  ## Examples

      iex> delete_rebalance_transaction(rebalance_transaction)
      {:ok, %RebalanceTransaction{}}

      iex> delete_rebalance_transaction(rebalance_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rebalance_transaction(%RebalanceTransaction{} = rebalance_transaction) do
    Repo.delete(rebalance_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rebalance_transaction changes.

  ## Examples

      iex> change_rebalance_transaction(rebalance_transaction)
      %Ecto.Changeset{source: %RebalanceTransaction{}}

  """
  def change_rebalance_transaction(%RebalanceTransaction{} = rebalance_transaction) do
    RebalanceTransaction.changeset(rebalance_transaction, %{})
  end

  def fetch_previous_prices(id, coins) do
    coins = Enum.map(coins, fn c -> c.symbol end)

    prices =
      Repo.all(
        from(
          t in Trade,
          where: t.rebalance_transaction_id == ^id and t.coin in ^coins,
          select: {t.coin, t.price},
          order_by: t.time,
          limit: ^(Enum.count(coins) - 1)
        )
      )

    prices =
      case prices do
        [] ->
          []

        prices ->
          Enum.map(prices, fn {coin, price} ->
            case Float.parse(price) do
              :error -> nil
              {val, _rem} -> {coin, val}
            end
          end)
      end

    case prices do
      [] -> {:ok, []}
      prices -> {:ok, [{"BTC", 1.0} | prices]}
    end
  end
end
