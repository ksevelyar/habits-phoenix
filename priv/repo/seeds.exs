# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Habits.Repo.insert!(%Habits.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Habits.Repo
alias Habits.Tasks.Task

Repo.insert!(%Task{
  name: "💊 Melatonin",
  cron: "0 23 * * *"
})

Repo.insert!(%Task{
  name: "📖 Book",
  cron: "30 23 * * *"
})

Repo.insert!(%Task{
  name: "🪥 Cleaning tooth",
  cron: "0 20 * * *"
})

Repo.insert!(%Task{
  name: "🏠 Vacuum floor + Laundry",
  cron: "0 13 * * 2,6"
})

Repo.insert!(%Task{
  name: "🛁 Clean bath",
  cron: "0 13 * * 5"
})

Repo.insert!(%Task{
  name: "⚡ Pullups",
  cron: "0 9 * * 1,5"
})

Repo.insert!(%Task{
  name: "⚡ Kettlebell",
  cron: "0 9 * * 3"
})

Repo.insert!(%Task{
  name: "🎸 Guitar",
  cron: "0 15 * * 1-5"
})

Repo.insert!(%Task{
  name: "📔 Review notes",
  cron: "0 9 * * 7"
})

Repo.insert!(%Task{
  name: "🏠 Collect meters",
  cron: "0 8 19 * *"
})

Repo.insert!(%Task{
  name: "🦷 replace interdental brushes",
  cron: "0 8 15 * *"
})

Repo.insert!(%Task{
  name: "🦷 Professional tooth cleaning",
  cron: "0 8 1 3,9 *"
})
