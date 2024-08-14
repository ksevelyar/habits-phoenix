defmodule Habits.Repo.Migrations.CreateMetrics do
  use Ecto.Migration

  def change do
    create table(:metrics) do
      add :value, :integer, null: false
      add :chain_id, references(:chains, on_delete: :delete_all), null: false
      add :date, :date, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:metrics, [:chain_id, :date])
  end
end
