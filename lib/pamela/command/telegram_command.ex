defmodule Pamela.Command.TelegramCommand do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.Command.TelegramCommand

  @primary_key {:update_id, :integer, []}
  @derive {Phoenix.Param, key: :update_id}
  schema "telegram_commands" do
    field :command, :string
    field :telegram_user_id, :integer
    field :executed, :boolean

    timestamps()
  end

  @doc false
  def changeset(%TelegramCommand{} = telegram_command, attrs) do
    telegram_command
    |> cast(attrs, [:update_id, :command, :telegram_user_id, :executed])
    |> validate_required([:update_id, :command, :telegram_user_id, :executed])
  end
end
