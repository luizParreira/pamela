defmodule Pamela.Trading do
  @moduledoc """
  The Trading context.
  """

  import Ecto.Query, warn: false
  alias Pamela.Repo

  alias Pamela.Trading.Session

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

  alias Pamela.Trading.Coin

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

  alias Pamela.Trading.Period

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

  alias Pamela.Trading.Trade

  def get_trades_by(transaction_id: id) do
    Repo.all(from(t in Trade, where: t.rebalance_transaction_id == ^id))
  end

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

  alias Pamela.Trading.RebalanceTransaction

  def get_rebalance_transactions_by(session_id: id) do
    Repo.all(from(t in RebalanceTransaction, where: t.session_id == ^id))
  end

  def fetch_latest_transaction(%Session{id: id}) do
    transaction =
      Repo.one(
        from(transaction in RebalanceTransaction,
          where: transaction.session_id == ^id,
          order_by: [desc: transaction.id],
          limit: 1
        )
      )

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

  def fetch_previous_prices(nil, _coins), do: {:ok, []}

  def fetch_previous_prices(transaction, coins) do
    coins = Enum.map(coins, fn c -> c.symbol end)

    prices =
      Repo.all(
        from(
          t in Trade,
          where: t.rebalance_transaction_id == ^transaction.id and t.coin in ^coins,
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

  alias Pamela.Trading.Balance

  @doc """
  Creates a balance.

  ## Examples

      iex> create_balance(%{field: value})
      {:ok, %Balance{}}

      iex> create_balance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_balance(attrs \\ %{}) do
    %Balance{}
    |> Balance.changeset(attrs)
    |> Repo.insert()
  end
end
