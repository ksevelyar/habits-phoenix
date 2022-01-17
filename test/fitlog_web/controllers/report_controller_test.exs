defmodule FitlogWeb.ReportControllerTest do
  use FitlogWeb.ConnCase

  import Fitlog.ReportsFixtures

  alias Fitlog.Reports.Report

  @create_attrs %{
    calories: "120.5",
    carbs: "120.5",
    date: ~D[2022-01-16],
    dumbbells: "120.5",
    fat: "120.5",
    protein: "120.5",
    stepper: 42,
    steps: 42,
    weight: "120.5"
  }
  @update_attrs %{
    calories: "456.7",
    carbs: "456.7",
    date: ~D[2022-01-17],
    dumbbells: "456.7",
    fat: "456.7",
    protein: "456.7",
    stepper: 43,
    steps: 43,
    weight: "456.7"
  }
  @invalid_attrs %{calories: nil, carbs: nil, date: nil, dumbbells: nil, fat: nil, protein: nil, stepper: nil, steps: nil, weight: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all reports", %{conn: conn} do
      conn = get(conn, Routes.report_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create report" do
    test "renders report when data is valid", %{conn: conn} do
      conn = post(conn, Routes.report_path(conn, :create), report: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.report_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "calories" => "120.5",
               "carbs" => "120.5",
               "date" => "2022-01-16",
               "dumbbells" => "120.5",
               "fat" => "120.5",
               "protein" => "120.5",
               "stepper" => 42,
               "steps" => 42,
               "weight" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.report_path(conn, :create), report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update report" do
    setup [:create_report]

    test "renders report when data is valid", %{conn: conn, report: %Report{id: id} = report} do
      conn = put(conn, Routes.report_path(conn, :update, report), report: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.report_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "calories" => "456.7",
               "carbs" => "456.7",
               "date" => "2022-01-17",
               "dumbbells" => "456.7",
               "fat" => "456.7",
               "protein" => "456.7",
               "stepper" => 43,
               "steps" => 43,
               "weight" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, report: report} do
      conn = put(conn, Routes.report_path(conn, :update, report), report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete report" do
    setup [:create_report]

    test "deletes chosen report", %{conn: conn, report: report} do
      conn = delete(conn, Routes.report_path(conn, :delete, report))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.report_path(conn, :show, report))
      end
    end
  end

  defp create_report(_) do
    report = report_fixture()
    %{report: report}
  end
end
