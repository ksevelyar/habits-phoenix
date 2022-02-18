defmodule Fitlog.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  @behaviour Bodyguard.Schema

  schema "reports" do
    field :calories, :integer
    field :carbs, :decimal
    field :date, :date
    field :dumbbells, :decimal
    field :fat, :decimal
    field :protein, :decimal
    field :stepper, :integer
    field :steps, :integer
    field :weight, :decimal

    belongs_to :user, Fitlog.Users.User

    timestamps()
  end

  def scope(query, %Fitlog.Users.User{id: user_id}, _) do
    from reports in query, where: reports.user_id == ^user_id
  end

  def changeset(report, attrs) do
    report
    |> cast(attrs, [
      :date,
      :stepper,
      :steps,
      :weight,
      :dumbbells,
      :protein,
      :fat,
      :carbs,
      :calories
    ])
    |> validate_required([
      :date,
      :stepper,
      :steps,
      :weight,
      :dumbbells,
      :protein,
      :fat,
      :carbs,
      :calories
    ])
    |> assoc_constraint(:user)
    |> unique_constraint([:user_id, :date])
  end
end
