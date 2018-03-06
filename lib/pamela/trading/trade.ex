defmodule Pamela.Trading.Trade do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Trading.Trade

  schema "trading_trades" do
    field(:amount, :string)
    field(:base, :string)
    field(:coin, :string)
    field(:price, :string)
    field(:rebalance_transaction_id, :integer)
    field(:side, :string)
    field(:order_id, :integer)
    field(:time, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(%Trade{} = trade, attrs) do
    trade
    |> cast(attrs, [
      :rebalance_transaction_id,
      :side,
      :base,
      :coin,
      :price,
      :amount,
      :time,
      :order_id
    ])
    |> validate_required([
      :rebalance_transaction_id,
      :base,
      :coin,
      :price,
      :time
    ])
  end
end
