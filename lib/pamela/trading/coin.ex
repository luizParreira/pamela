defmodule Pamela.Trading.Coin do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Trading.Coin


  schema "trading_coins" do
    field :base, :boolean, default: false
    field :session_id, :integer
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(%Coin{} = coin, attrs) do
    coin
    |> cast(attrs, [:symbol, :session_id, :base])
    |> validate_required([:symbol, :session_id, :base])
  end
end
