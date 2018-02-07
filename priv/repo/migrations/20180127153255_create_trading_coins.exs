defmodule Pamela.Repo.Migrations.CreateTradingCoins do
  use Ecto.Migration

  def change do
    create table(:trading_coins) do
      add :symbol, :string
      add :session_id, references(:trading_sessions)
      add :base, :boolean, default: false, null: false

      timestamps()
    end

  end
end
