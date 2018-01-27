defmodule Pamela.Trading.Period do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Trading.Period


  schema "trading_periods" do
    field :period, :string
    field :session_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Period{} = period, attrs) do
    period
    |> cast(attrs, [:period, :session_id])
    |> validate_required([:period, :session_id])
  end
end
