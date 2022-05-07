defmodule Fitlog.ReportsFixtures do
  def report_fixture(user, attrs \\ %{}) do
    report_attrs =
      attrs
      |> Enum.into(%{
        date: ~D[2022-01-16],
        weight: "79.5",
        stepper: 2000,
        steps: 6000,
        dumbbell_sets: 3,
        kettlebell_sets: 2,
        pullups: 10,
        protein_meals: 3,
        fiber_meals: 5
      })

    {:ok, report} = Fitlog.Reports.create_report(user, report_attrs)
    report
  end
end
