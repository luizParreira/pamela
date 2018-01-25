defmodule Pamela.Repo.Migrations.MakeUserDataOptional do
  use Ecto.Migration
  def change do
    alter table(:telegram_users) do
      modify :first_name, :string, null: true
      modify :last_name, :string, null: true
    end
  end
end
