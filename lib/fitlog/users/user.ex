defmodule Fitlog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Argon2

  schema "users" do
    field :email, :string
    field :handle, :string
    field :raw_password, :string, virtual: true
    field :password, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:handle, :email])
    |> validate_required([:handle, :email])
    |> validate_length(:handle, min: 3, max: 12)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:handle, ~r/^\w+$/)
    |> unique_constraint(:email)
    |> unique_constraint(:handle)
  end

  def registration_changeset(user, attrs) do
    changeset(user, attrs)
    |> cast(attrs, [:raw_password])
    |> validate_length(:password, min: 6)
    |> hash_password()
  end

  defp hash_password(%{changes: %{raw_password: raw_password}} = user) do
    change(user, password: Argon2.hash_pwd_salt(raw_password))
  end

  defp hash_password(changeset), do: changeset
end
