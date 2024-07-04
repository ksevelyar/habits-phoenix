defmodule Fitlog.Repo.Migrations.AddSleepToReports do
  use Ecto.Migration

  def change do
    alter table("reports") do
      add :sleep, :integer
    end
  end
end
