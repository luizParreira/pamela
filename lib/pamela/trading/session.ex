defmodule Pamela.Trading.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Trading.Session

  schema "trading_sessions" do
    field(:name, :string)
    field(:running, :boolean)
    field(:telegram_user_id, :integer)
    field(:command_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:name, :running, :telegram_user_id, :command_id])
    |> foreign_key_constraint(:telegram_user_id)
    |> validate_required([:name, :running, :telegram_user_id, :command_id])
  end
end
