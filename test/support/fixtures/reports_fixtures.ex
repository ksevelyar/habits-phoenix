defmodule Fitlog.ReportsFixtures do
  def report_fixture(user, attrs \\ %{}) do
    report_attrs =
      attrs
      |> Enum.into(%{
        calories: 1200,
        carbs: "120.5",
        date: ~D[2022-01-16],
        dumbbells: "120.5",
        fat: "120.5",
        protein: "120.5",
        stepper: 42,
        steps: 42,
        weight: "120.5"
      })

    {:ok, report} = Fitlog.Reports.create_report(user, report_attrs)
    report
  end
end
