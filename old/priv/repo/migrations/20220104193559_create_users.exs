defmodule Fitlog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :handle, :string, null: false
      add :email, :string, null: false
      add :avatar_url, :string, null: false
      add :github_id, :integer, null: false
      timestamps()
    end

    create unique_index(:users, [:handle])
    create unique_index(:users, [:github_id])
  end
end
