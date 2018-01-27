defmodule Pamela.Repo.Migrations.AddExecutedFlagToCommands do
  use Ecto.Migration

  def change do
    alter table(:telegram_commands) do
      add :executed, :boolean, null: false, default: false
    end
  end
end
