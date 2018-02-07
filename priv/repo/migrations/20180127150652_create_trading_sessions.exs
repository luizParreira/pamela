defmodule Pamela.Repo.Migrations.CreateTradingSessions do
  use Ecto.Migration

  def change do
    create table(:trading_sessions) do
      add :name, :string
      add :running, :boolean, null: false, default: false
      add :telegram_user_id, references(:telegram_users)

      timestamps()
    end

  end
end
