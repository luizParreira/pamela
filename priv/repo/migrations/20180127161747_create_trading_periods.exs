defmodule Pamela.Repo.Migrations.CreateTradingPeriods do
  use Ecto.Migration

  def change do
    create table(:trading_periods) do
      add :period, :string
      add :session_id, :integer

      timestamps()
    end

  end
end
