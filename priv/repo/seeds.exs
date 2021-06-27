# Script for populating the database. You can run it as:
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Fitlog.Repo
alias Fitlog.Reports.Report

Repo.insert!(%Report{date: Date.utc_today(), weight: 89})
Repo.insert!(%Report{date: Date.utc_today() |> Date.add(-1), weight: 90})
Repo.insert!(%Report{date: Date.utc_today() |> Date.add(-2), weight: 91})
