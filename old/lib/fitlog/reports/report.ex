defmodule Fitlog.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Fitlog.Repo
  alias Fitlog.Reports.Report
  @behaviour Bodyguard.Schema

  schema "reports" do
    belongs_to :user, Fitlog.Users.User
    field :date, :date

    field :sleep, :integer
    field :stepper, :integer
    field :steps, :integer
    field :weight, :decimal

    field :kettlebell_sets, :integer
    field :pullups, :integer

    field :protein_meals, :integer
    field :fiber_meals, :integer

    timestamps()
  end

  def scope(query, %Fitlog.Users.User{id: user_id}, _) do
    from reports in query, where: reports.user_id == ^user_id
  end

  def list_user_reports(user, limit) do
    from(r in Report, order_by: [desc: r.date], limit: ^limit)
    |> Bodyguard.scope(user)
    |> Repo.all()
  end

  def today_report(user) do
    today = Date.utc_today()
    query = from reports in Report, where: reports.date == ^today

    query |> Bodyguard.scope(user) |> first |> Repo.one()
  end

  def changeset(report, attrs) do
    report
    |> cast(attrs, [
      :date,
      :sleep,
      :stepper,
      :steps,
      :weight,
      :kettlebell_sets,
      :pullups,
      :protein_meals,
      :fiber_meals
    ])
    |> validate_required([:date])
    |> assoc_constraint(:user)
    |> unique_constraint([:date, :user_id])
  end
end
