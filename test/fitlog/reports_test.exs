defmodule Fitlog.ReportsTest do
  use Fitlog.DataCase

  alias Fitlog.Reports

  describe "reports" do
    alias Fitlog.Reports.Report

    @valid_attrs %{calories: "120.5", carbs: "120.5", date: ~D[2010-04-17], dumbbell_sets: 42, dumbell_weight: "120.5", fat: "120.5", protein: "120.5", stepper_steps: 42, steps: 42, user_id: 42, weight: "120.5"}
    @update_attrs %{calories: "456.7", carbs: "456.7", date: ~D[2011-05-18], dumbbell_sets: 43, dumbell_weight: "456.7", fat: "456.7", protein: "456.7", stepper_steps: 43, steps: 43, user_id: 43, weight: "456.7"}
    @invalid_attrs %{calories: nil, carbs: nil, date: nil, dumbbell_sets: nil, dumbell_weight: nil, fat: nil, protein: nil, stepper_steps: nil, steps: nil, user_id: nil, weight: nil}

    def report_fixture(attrs \\ %{}) do
      {:ok, report} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reports.create_report()

      report
    end

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert Reports.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Reports.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      assert {:ok, %Report{} = report} = Reports.create_report(@valid_attrs)
      assert report.calories == Decimal.new("120.5")
      assert report.carbs == Decimal.new("120.5")
      assert report.date == ~D[2010-04-17]
      assert report.dumbbell_sets == 42
      assert report.dumbell_weight == Decimal.new("120.5")
      assert report.fat == Decimal.new("120.5")
      assert report.protein == Decimal.new("120.5")
      assert report.stepper_steps == 42
      assert report.steps == 42
      assert report.user_id == 42
      assert report.weight == Decimal.new("120.5")
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      assert {:ok, %Report{} = report} = Reports.update_report(report, @update_attrs)
      assert report.calories == Decimal.new("456.7")
      assert report.carbs == Decimal.new("456.7")
      assert report.date == ~D[2011-05-18]
      assert report.dumbbell_sets == 43
      assert report.dumbell_weight == Decimal.new("456.7")
      assert report.fat == Decimal.new("456.7")
      assert report.protein == Decimal.new("456.7")
      assert report.stepper_steps == 43
      assert report.steps == 43
      assert report.user_id == 43
      assert report.weight == Decimal.new("456.7")
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_report(report, @invalid_attrs)
      assert report == Reports.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = Reports.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Reports.change_report(report)
    end
  end
end
