defmodule Pamela.Repo.Migrations.CreateTelegramUsers do
  use Ecto.Migration

  def change do
    create table(:telegram_users, primary_key: false) do
      add(:id, :integer, primary_key: true)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:username, :string)

      timestamps()
    end
  end
end
