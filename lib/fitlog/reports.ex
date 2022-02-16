defmodule Fitlog.Reports do
  alias Fitlog.Repo
  alias Fitlog.Reports.Report

defdelegate authorize(action, user, params), to: Fitlog.Reports.Policy

  def list_reports do
    Repo.all(Report)
  end

  def get_report!(id), do: Repo.get!(Report, id)

  def create_report(user, attrs) do
    Ecto.build_assoc(user, :reports)
    |> change_report(attrs)
    |> Repo.insert()
  end

  def update_report(%Report{} = report, attrs) do
    report
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  def delete_report(%Report{} = report) do
    Repo.delete(report)
  end

  def change_report(%Report{} = report, attrs \\ %{}) do
    Report.changeset(report, attrs)
  end
end
