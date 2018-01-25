defmodule Pamela.Repo.Migrations.CreateTelegramCommands do
  use Ecto.Migration

  def change do
    create table(:telegram_commands, primary_key: false) do
      add :update_id, :integer, primary_key: true
      add :command, :string
      add :telegram_user_id, references(:telegram_users)

      timestamps()
    end

  end
end
