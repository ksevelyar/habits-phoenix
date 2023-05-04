defmodule Fitlog.ReportsTest do
  use Fitlog.DataCase

  import Fitlog.UsersFixtures
  import Fitlog.Factory

  defp report_with_user do
    user = user_fixture()
    report = insert(:report, user_id: user.id)

    {report, user}
  end

  describe "reports" do
    alias Fitlog.Reports
    alias Fitlog.Reports.Report

    @invalid_attrs %{
      date: nil
    }

    test "list_user_reports/2 returns user reports" do
      {report, user} = report_with_user()
      assert Reports.list_user_reports(user, 1) == [report]
    end

    test "list_user_reports/2 returns reports for two weeks" do
      user = user_fixture()
      insert_list(21, :report, user: user)

      assert Reports.list_user_reports(user, 14) |> Enum.count() == 14
    end

    test "get_report!/1 returns the report with given id" do
      {report, _user} = report_with_user()
      assert Reports.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      valid_attrs = %{
        date: ~D[2022-01-16],
        stepper: 42,
        steps: 42,
        weight: "120.5"
      }

      assert {:ok, %Report{} = report} = Reports.upsert(user_fixture(), valid_attrs)
      assert report.date == ~D[2022-01-16]
      assert report.stepper == 42
      assert report.steps == 42
      assert report.weight == Decimal.new("120.5")
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.upsert(user_fixture(), @invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      {_report, user} = report_with_user()

      update_attrs = %{
        date: ~D[2022-01-17],
        stepper: 1000,
        steps: 6000,
        weight: "77.7"
      }

      assert {:ok, %Report{} = report} = Reports.upsert(user, update_attrs)
      assert report.date == ~D[2022-01-17]
      assert report.stepper == 1000
      assert report.steps == 6000
      assert report.weight == Decimal.new("77.7")
    end

    test "update_report/2 with invalid data returns error changeset" do
      {report, user} = report_with_user()
      assert {:error, %Ecto.Changeset{}} = Reports.upsert(user, @invalid_attrs)
      assert report == Reports.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      {report, _user} = report_with_user()
      assert {:ok, %Report{}} = Reports.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      {report, _user} = report_with_user()
      assert %Ecto.Changeset{} = Reports.change_report(report)
    end
  end
end
