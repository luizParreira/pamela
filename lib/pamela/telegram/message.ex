defmodule Pamela.Telegram.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Telegram.Message

  @primary_key {:update_id, :integer, []}
  @derive {Phoenix.Param, key: :update_id}
  schema "telegram_messages" do
    field(:text, :string)
    field(:type, :string)
    field(:user_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:update_id, :text, :type, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:update_id, :text, :type, :user_id])
  end
end
