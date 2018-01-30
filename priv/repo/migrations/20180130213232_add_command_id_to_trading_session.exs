defmodule Pamela.Repo.Migrations.AddCommandIdToTradingSession do
  use Ecto.Migration

  def change do
    alter table(:trading_sessions) do
      add :command_id, references(:telegram_commands, column: :update_id)
    end
  end
end
