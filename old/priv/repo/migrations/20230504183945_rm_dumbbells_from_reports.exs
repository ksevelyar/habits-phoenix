defmodule Fitlog.Repo.Migrations.RmDumbbellsFromReports do
  use Ecto.Migration

  def change do
    alter table(:reports) do
      remove :dumbbell_sets
    end
  end
end
