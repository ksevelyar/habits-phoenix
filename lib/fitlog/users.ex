defmodule Fitlog.Users do
  import Ecto.Query, warn: false
  alias Fitlog.Repo
  alias Fitlog.Users.User

  def list do
    Repo.all(User)
  end

  def get!(id), do: Repo.get!(User, id)

  def get_by_handle(handle) do
    from(u in User, where: u.handle == ^handle)
    |> Repo.one()
    |> Repo.preload(:reports)
  end

  def upsert(user) do
    Repo.insert(
      User.changeset(%User{}, user),
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: :github_id,
      returning: true
    )
  end

  def delete(%User{} = user) do
    Repo.delete(user)
  end

  def change(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
