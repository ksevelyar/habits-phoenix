defmodule Fitlog.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    field :calories, :decimal
    field :carbs, :decimal
    field :date, :date
    field :dumbbell_sets, :integer
    field :dumbell_weight, :decimal
    field :fat, :decimal
    field :protein, :decimal
    field :stepper_steps, :integer
    field :steps, :integer
    field :user_id, :integer
    field :weight, :decimal

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:user_id, :date, :stepper_steps, :steps, :weight, :dumbbell_sets, :dumbell_weight, :protein, :fat, :carbs, :calories])
    |> validate_required([:user_id, :date, :stepper_steps, :steps, :weight, :dumbbell_sets, :dumbell_weight, :protein, :fat, :carbs, :calories])
  end
end
