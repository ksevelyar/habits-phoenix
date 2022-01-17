defmodule FitlogWeb.ReportController do
  use FitlogWeb, :controller

  alias Fitlog.Reports
  alias Fitlog.Reports.Report

  action_fallback FitlogWeb.FallbackController

  def index(conn, _params) do
    reports = Reports.list_reports()
    render(conn, "index.json", reports: reports)
  end

  def create(conn, %{"report" => report_params}) do
    with {:ok, %Report{} = report} <- Reports.create_report(report_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.report_path(conn, :show, report))
      |> render("show.json", report: report)
    end
  end

  def show(conn, %{"id" => id}) do
    report = Reports.get_report!(id)
    render(conn, "show.json", report: report)
  end

  def update(conn, %{"id" => id, "report" => report_params}) do
    report = Reports.get_report!(id)

    with {:ok, %Report{} = report} <- Reports.update_report(report, report_params) do
      render(conn, "show.json", report: report)
    end
  end

  def delete(conn, %{"id" => id}) do
    report = Reports.get_report!(id)

    with {:ok, %Report{}} <- Reports.delete_report(report) do
      send_resp(conn, :no_content, "")
    end
  end
end
