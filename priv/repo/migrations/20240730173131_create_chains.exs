defmodule Habits.Repo.Migrations.CreateChains do
  use Ecto.Migration

  def change do
    create table(:chains) do
      add :name, :string, null: false
      add :description, :string
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :active, :boolean, default: true, null: false
      add :time_range, :string
      add :days_of_month, :string
      add :days_of_week, :string
      add :months, :string

      timestamps(type: :utc_datetime)
    end

    create index(:chains, [:user_id])
  end
end
