defmodule Pamela.Repo.Migrations.CreateTelegramCommandMessages do
  use Ecto.Migration

  def change do
    create table(:telegram_command_messages) do
      add(:telegram_command_update_id, references(:telegram_commands, column: :message_id))
      add(:message, :string)

      timestamps()
    end

    create(index(:telegram_command_messages, [:message]))
  end
end
