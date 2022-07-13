defmodule Fitlog.Factory do
  use ExMachina.Ecto, repo: Fitlog.Repo

  defp date_seq(shift), do: DateTime.utc_now() |> Date.add(shift)
  defp random_or_null(range), do: [Enum.random(range), nil] |> Enum.random()

  def report_factory do
    date = sequence(:date, &date_seq/1)

    %Fitlog.Reports.Report{
      date: date,
      weight: "77",
      stepper: random_or_null(500..2000),
      steps: random_or_null(3000..15000),
      dumbbell_sets: random_or_null(1..5),
      kettlebell_sets: random_or_null(1..5),
      pullups: random_or_null(5..50),
      protein_meals: random_or_null(1..5),
      fiber_meals: random_or_null(1..5)
    }
  end
end
