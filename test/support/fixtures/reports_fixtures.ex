defmodule Fitlog.ReportsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fitlog.Reports` context.
  """

  @doc """
  Generate a report.
  """
  def report_fixture(attrs \\ %{}) do
    {:ok, report} =
      attrs
      |> Enum.into(%{
        calories: "120.5",
        carbs: "120.5",
        date: ~D[2022-01-16],
        dumbbells: "120.5",
        fat: "120.5",
        protein: "120.5",
        stepper: 42,
        steps: 42,
        weight: "120.5"
      })
      |> Fitlog.Reports.create_report()

    report
  end
end
