defmodule Habits.Repo.Migrations.RemoveRecurringAndTypeFromTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :type
      remove :recurring
    end
  end
end
