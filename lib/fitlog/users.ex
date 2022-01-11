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
  end

  def upsert(user) do
    case get_by_handle(user.handle) do
      nil -> User.changeset(%User{}, user) |> Repo.insert()
      record -> {:ok, record}
    end
  end

  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete(%User{} = user) do
    Repo.delete(user)
  end

  def change(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
