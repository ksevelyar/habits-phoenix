defmodule Habits.Repo.Migrations.AddOrderToChains do
  use Ecto.Migration

  def change do
    alter table(:chains) do
      add :order, :integer, null: false, default: 0
    end
  end
end
