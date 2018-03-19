defmodule Pamela.Trading.Balance do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Trading.Balance

  schema "trading_balances" do
    field(:balance, :float)
    field(:coin, :string)
    field(:rebalance_transaction_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Balance{} = balance, attrs) do
    balance
    |> cast(attrs, [:balance, :coin, :rebalance_transaction_id])
    |> validate_required([:balance, :coin, :rebalance_transaction_id])
  end
end
