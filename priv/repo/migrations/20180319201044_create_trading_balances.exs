defmodule Pamela.Repo.Migrations.CreateTradingBalances do
  use Ecto.Migration

  def change do
    create table(:trading_balances) do
      add(:balance, :float)
      add(:coin, :string)
      add(:rebalance_transaction_id, references(:trading_rebalance_transactions))

      timestamps()
    end
  end
end
