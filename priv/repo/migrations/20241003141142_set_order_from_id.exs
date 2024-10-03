defmodule Habits.Repo.Migrations.SetOrderFromId do
  use Ecto.Migration

  def change do
    execute "UPDATE chains SET \"order\" = \"id\""
  end
end
