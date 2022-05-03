defmodule Fitlog.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :date, :date, null: false
      add :stepper, :integer
      add :steps, :integer
      add :weight, :decimal
      add :dumbbell_sets, :integer
      add :pullups, :integer
      add :protein, :decimal
      add :fat, :decimal
      add :carbs, :decimal
      add :calories, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:reports, [:user_id])
  end
end
