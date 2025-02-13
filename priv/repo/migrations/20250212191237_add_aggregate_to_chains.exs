defmodule Habits.Repo.Migrations.AddAggregateToChains do
  use Ecto.Migration

  def change do
    alter table(:chains) do
      add :aggregate, :string, null: false, default: "sum"
    end
  end
end
