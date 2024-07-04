defmodule Fitlog.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :date, :date, null: false
      add :weight, :decimal

      add :stepper, :integer
      add :steps, :integer
      add :dumbbell_sets, :integer
      add :kettlebell_sets, :integer
      add :pullups, :integer

      add :protein_meals, :integer
      add :fiber_meals, :integer

      timestamps()
    end

    create index(:reports, [:user_id])
    create unique_index(:reports, [:date, :user_id])
  end
end
