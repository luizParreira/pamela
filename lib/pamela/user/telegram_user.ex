defmodule Pamela.User.TelegramUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pamela.User.TelegramUser

  @primary_key {:id, :integer, []}
  @derive {Phoenix.Param, key: :id}
  schema "telegram_users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(%Nadia.Model.User{} = telegram_user, attrs),
    do: execute_changeset(telegram_user, attrs)

  def changeset(%TelegramUser{} = telegram_user, attrs),
    do: execute_changeset(telegram_user, attrs)

  def execute_changeset(%TelegramUser{} = telegram_user, attrs) do
    telegram_user
    |> cast(attrs, [:id, :first_name, :last_name, :username])
    |> validate_required([:id, :username])
  end
end
