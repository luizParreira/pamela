defmodule Pamela.Repo.Migrations.AddCommandIdToTradingSession do
  use Ecto.Migration

  def change do
    alter table(:trading_sessions) do
      add(:command_id, references(:telegram_commands, column: :message_id))
    end
  end
end
