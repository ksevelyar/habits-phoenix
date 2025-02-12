defmodule Habits.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :type, :string
      add :active, :boolean, default: false, null: false
      add :cron, :string
      add :recurring, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :notified_at, :utc_datetime_usec

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:user_id])
  end
end
