defmodule Fitlog.ReportsTest do
  use Fitlog.DataCase

  import Fitlog.UsersFixtures
  import Fitlog.ReportsFixtures

  defp report_with_user do
    user = user_fixture()
    {report_fixture(user), user}
  end

  describe "reports" do
    alias Fitlog.Reports
    alias Fitlog.Reports.Report

    @invalid_attrs %{
      calories: nil,
      carbs: nil,
      date: nil,
      dumbbell_sets: nil,
      fat: nil,
      protein: nil,
      stepper: nil,
      steps: nil,
      weight: nil
    }

    test "list_user_reports/1 returns user reports" do
      {report, user} = report_with_user()
      assert Reports.list_user_reports(user) == [report]
    end

    test "get_report!/1 returns the report with given id" do
      {report, _user} = report_with_user()
      assert Reports.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      valid_attrs = %{
        calories: 1200,
        carbs: "120.5",
        date: ~D[2022-01-16],
        dumbbell_sets: 9,
        fat: "120.5",
        protein: "120.5",
        stepper: 42,
        steps: 42,
        weight: "120.5"
      }

      assert {:ok, %Report{} = report} = Reports.create_report(user_fixture(), valid_attrs)
      assert report.calories == 1200
      assert report.carbs == Decimal.new("120.5")
      assert report.date == ~D[2022-01-16]
      assert report.dumbbell_sets == 9
      assert report.fat == Decimal.new("120.5")
      assert report.protein == Decimal.new("120.5")
      assert report.stepper == 42
      assert report.steps == 42
      assert report.weight == Decimal.new("120.5")
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_report(user_fixture(), @invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      {report, _user} = report_with_user()

      update_attrs = %{
        calories: 600,
        carbs: "456.7",
        date: ~D[2022-01-17],
        dumbbell_sets: 10,
        fat: "456.7",
        protein: "456.7",
        stepper: 1000,
        steps: 6000,
        weight: "77.7"
      }

      assert {:ok, %Report{} = report} = Reports.update_report(report, update_attrs)
      assert report.calories == 600
      assert report.carbs == Decimal.new("456.7")
      assert report.date == ~D[2022-01-17]
      assert report.dumbbell_sets == 10
      assert report.fat == Decimal.new("456.7")
      assert report.protein == Decimal.new("456.7")
      assert report.stepper == 1000
      assert report.steps == 6000
      assert report.weight == Decimal.new("77.7")
    end

    test "update_report/2 with invalid data returns error changeset" do
      {report, _user} = report_with_user()
      assert {:error, %Ecto.Changeset{}} = Reports.update_report(report, @invalid_attrs)
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
