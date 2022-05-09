defmodule FitlogWeb.ReportController do
  use FitlogWeb, :controller

  alias Fitlog.Reports
  alias Fitlog.Reports.Report

  action_fallback FitlogWeb.FallbackController

  defp current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def index(conn, _params) do
    user = current_user(conn)
    reports = Reports.list_user_reports(user)

    render(conn, "index.json", reports: reports)
  end

  def show(conn, _params) do
    user = current_user(conn)
    report = Reports.today_report(user)

    render(conn, "show.json", report: report)
  end

  def create(conn, %{"report" => report_params}) do
    user = current_user(conn)

    with {:ok, %Report{} = report} <- Reports.upsert(user, report_params) do
      conn
      |> put_status(:created)
      |> render("show.json", report: report)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = current_user(conn)
    report = Reports.get_report!(id)

    with :ok <- Bodyguard.permit(Fitlog.Reports, :delete, user, report),
         {:ok, %Report{}} <- Reports.delete_report(report) do
      send_resp(conn, :no_content, "")
    end
  end
end
