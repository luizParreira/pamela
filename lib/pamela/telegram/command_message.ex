defmodule Pamela.Telegram.CommandMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Telegram.CommandMessage

  schema "telegram_command_messages" do
    field(:message, :string)
    field(:telegram_command_update_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%CommandMessage{} = telegram_command_message, attrs) do
    telegram_command_message
    |> cast(attrs, [:telegram_command_update_id, :message])
    |> foreign_key_constraint(:telegram_command_update_id)
    |> validate_required([:telegram_command_update_id, :message])
  end
end
