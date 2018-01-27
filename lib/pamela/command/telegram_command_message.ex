defmodule Pamela.Command.TelegramCommandMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Command.TelegramCommandMessage


  schema "telegram_command_messages" do
    field :message, :string
    field :telegram_command_update_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%TelegramCommandMessage{} = telegram_command_message, attrs) do
    telegram_command_message
    |> cast(attrs, [:telegram_command_update_id, :message])
    |> validate_required([:telegram_command_update_id, :message])
  end
end
