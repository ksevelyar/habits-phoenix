defmodule Fitlog.Factory do
  use ExMachina.Ecto, repo: Fitlog.Repo

  defp date_seq(shift) do
    DateTime.utc_now |> Date.add(shift)
  end

  def report_factory do
    date = sequence(:date, &date_seq/1)

    %Fitlog.Reports.Report{
        date: date,
        weight: "77",
        stepper: 2000,
        steps: Enum.random(3000..15000),
        dumbbell_sets: 3,
        kettlebell_sets: 2,
        pullups: 10,
        protein_meals: 3,
        fiber_meals: 5
    }
  end
end
