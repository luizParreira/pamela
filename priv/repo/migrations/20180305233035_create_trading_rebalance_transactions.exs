defmodule Pamela.Repo.Migrations.CreateTradingRebalanceTransactions do
  use Ecto.Migration

  def change do
    create table(:trading_rebalance_transactions) do
      add(:session_id, references(:trading_sessions))
      add(:time, :utc_datetime)

      timestamps()
    end
  end
end
