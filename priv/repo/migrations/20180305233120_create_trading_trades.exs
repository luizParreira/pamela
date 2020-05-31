defmodule Pamela.Repo.Migrations.CreateTradingTrades do
  use Ecto.Migration

  def change do
    create table(:trading_trades) do
      add(:rebalance_transaction_id, references(:trading_rebalance_transactions))
      add(:side, :string)
      add(:base, :string)
      add(:coin, :string)
      add(:price, :string)
      add(:amount, :string)
      add(:order_id, :bigint)
      add(:time, :utc_datetime)

      timestamps()
    end
  end
end
