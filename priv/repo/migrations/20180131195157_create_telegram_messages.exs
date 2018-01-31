defmodule Pamela.Repo.Migrations.CreateTelegramMessages do
  use Ecto.Migration

  def change do
    create table(:telegram_messages, primary_key: false) do
      add(:update_id, :integer, primary_key: true)
      add(:text, :string)
      add(:type, :string)
      add(:user_id, references(:telegram_users))

      timestamps()
    end
  end
end
