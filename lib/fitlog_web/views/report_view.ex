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
    %{id: report.id,
      date: report.date,
      stepper_steps: report.stepper_steps,
      steps: report.steps,
      weight: report.weight,
      dumbbell_sets: report.dumbbell_sets,
      dumbell_weight: report.dumbell_weight,
      protein: report.protein,
      fat: report.fat,
      carbs: report.carbs,
      calories: report.calories}
  end
end
