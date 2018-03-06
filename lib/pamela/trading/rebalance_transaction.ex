defmodule Pamela.Trading.RebalanceTransaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Trading.RebalanceTransaction

  schema "trading_rebalance_transactions" do
    field(:session_id, :integer)
    field(:time, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(%RebalanceTransaction{} = rebalance_transaction, attrs) do
    rebalance_transaction
    |> cast(attrs, [:session_id, :time])
    |> validate_required([:session_id, :time])
  end
end
