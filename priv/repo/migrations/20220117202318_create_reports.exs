defmodule Fitlog.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :date, :date
      add :stepper, :integer
      add :steps, :integer
      add :weight, :decimal
      add :dumbbells, :decimal
      add :protein, :decimal
      add :fat, :decimal
      add :carbs, :decimal
      add :calories, :decimal
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:reports, [:user_id])
  end
end
