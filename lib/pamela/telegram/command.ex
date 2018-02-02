defmodule Pamela.Telegram.Command do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Telegram

  @primary_key {:message_id, :integer, []}
  @derive {Phoenix.Param, key: :message_id}
  schema "telegram_commands" do
    field(:command, :string)
    field(:telegram_user_id, :integer)
    field(:executed, :boolean)

    timestamps()
  end

  @doc false
  def changeset(%Telegram.Command{} = telegram_command, attrs) do
    telegram_command
    |> cast(attrs, [:message_id, :command, :telegram_user_id, :executed])
    |> validate_required([:message_id, :command, :telegram_user_id, :executed])
  end
end
