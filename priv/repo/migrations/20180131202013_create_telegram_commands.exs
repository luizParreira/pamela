defmodule Pamela.Repo.Migrations.CreateTelegramCommands do
  use Ecto.Migration

  def change do
    create table(:telegram_commands, primary_key: false) do
      add(:message_id, references(:telegram_messages, column: :update_id), primary_key: true)
      add(:command, :string)
      add(:telegram_user_id, references(:telegram_users))
      add(:executed, :boolean, null: false, default: false)
      timestamps()
    end
  end
end
