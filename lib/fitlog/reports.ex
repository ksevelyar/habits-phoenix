defmodule Fitlog.Reports do
  alias Fitlog.Repo
  alias Fitlog.Reports.Report

  defdelegate authorize(action, user, params), to: Fitlog.Reports.Policy

  def list_user_reports(user) do
    Report
    |> Bodyguard.scope(user)
    |> Repo.all()
  end

  def today_report(user) do
    Report.today_report(user)
  end

  def get_report!(id), do: Repo.get!(Report, id)

  def upsert(user, attrs) do
    report_changeset = Ecto.build_assoc(user, :reports) |> change_report(attrs)

    Repo.insert(
      report_changeset,
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: [:user_id, :date],
      returning: true
    )
  end

  def delete_report(%Report{} = report) do
    Repo.delete(report)
  end

  def change_report(%Report{} = report, attrs \\ %{}) do
    Report.changeset(report, attrs)
  end
end
