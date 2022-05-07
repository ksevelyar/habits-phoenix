defmodule FitlogWeb.ReportView do
  use FitlogWeb, :view
  alias FitlogWeb.ReportView

  def render("index.json", %{reports: reports}) do
    %{data: render_many(reports, ReportView, "report.json")}
  end

  def render("show.json", %{report: report}) do
    %{data: render_one(report, ReportView, "report.json")}
  end

  def render("report.json", %{report: report}) do
    %{
      id: report.id,
      date: report.date,
      weight: report.weight,
      stepper: report.stepper,
      steps: report.steps,
      dumbbell_sets: report.dumbbell_sets,
      kettlebell_sets: report.kettlebell_sets,
      pullups: report.pullups,
      protein_meals: report.protein_meals,
      fiber_meals: report.fiber_meals,
      updated_at: report.updated_at
    }
  end
end
