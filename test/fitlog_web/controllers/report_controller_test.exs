defmodule FitlogWeb.ReportControllerTest do
  use FitlogWeb.ConnCase

  import Fitlog.UsersFixtures
  import Fitlog.Factory

  @create_attrs %{
    date: ~D[2022-01-16],
    dumbbell_sets: 9,
    pullups: 20,
    stepper: 42,
    steps: 42,
    weight: "120.5"
  }
  @update_attrs %{
    date: ~D[2022-01-16],
    dumbbell_sets: 10,
    pullups: 25,
    stepper: 43,
    steps: 43,
    weight: "456.7"
  }
  @invalid_attrs %{
    date: nil
  }

  defp login(conn, user) do
    Fitlog.Users.Guardian.Plug.sign_in(conn, user)
    |> Guardian.Plug.VerifySession.call([])
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_report]

    test "lists user reports", %{conn: conn, user: user} do
      conn_with_user = login(conn, user)

      conn = get(conn_with_user, Routes.report_path(conn, :index))

      assert json_response(conn, 200)
    end
  end

  describe "create report" do
    test "renders report when data is valid", %{conn: conn} do
      conn_with_user = login(conn, user_fixture())
      report = post(conn_with_user, Routes.report_path(conn, :create), report: @create_attrs)

      assert %{
               "date" => "2022-01-16",
               "dumbbell_sets" => 9,
               "stepper" => 42,
               "steps" => 42,
               "weight" => "120.5"
             } = json_response(report, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn_with_user = login(conn, user_fixture())
      conn = post(conn_with_user, Routes.report_path(conn, :create), report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update report" do
    setup [:create_report]

    test "renders report when data is valid", %{
      conn: conn,
      user: user
    } do
      conn_with_user = login(conn, user)

      report = post(conn_with_user, Routes.report_path(conn, :create), report: @update_attrs)

      assert %{
               "date" => "2022-01-16",
               "dumbbell_sets" => 10,
               "stepper" => 43,
               "steps" => 43,
               "weight" => "456.7"
             } = json_response(report, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn_with_user = login(conn, user)

      conn = post(conn_with_user, Routes.report_path(conn, :create), report: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete report" do
    setup [:create_report]

    test "deletes chosen report", %{conn: conn, report: report, user: user} do
      conn_with_user = login(conn, user)

      delete_conn = delete(conn_with_user, Routes.report_path(conn, :delete, report))
      assert response(delete_conn, 204)
    end
  end

  defp create_report(_) do
    user = user_fixture()
    report = insert(:report, user: user)

    %{report: report, user: user}
  end
end
