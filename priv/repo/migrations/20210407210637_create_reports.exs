defmodule Fitlog.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :user_id, :integer
      add :date, :date
      add :stepper_steps, :integer
      add :steps, :integer
      add :weight, :decimal
      add :dumbbell_sets, :integer
      add :dumbell_weight, :decimal
      add :protein, :decimal
      add :fat, :decimal
      add :carbs, :decimal
      add :calories, :decimal

      timestamps()
    end
  end
end
