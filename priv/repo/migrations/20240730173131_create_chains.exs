defmodule Habits.Repo.Migrations.CreateChains do
  use Ecto.Migration

  def change do
    create table(:chains) do
      add :name, :string, null: false
      add :description, :string
      add :type, :string, null: false
      add :active, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:chains, [:user_id])
  end
end
