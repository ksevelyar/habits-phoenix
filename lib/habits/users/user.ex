defmodule Habits.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :handle, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:handle, :email, :password])
    |> validate_email()
    |> validate_handle()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Habits.Repo)
    |> unique_constraint(:email)
  end

  defp validate_handle(changeset) do
    changeset
    |> validate_required([:handle])
    |> validate_format(:handle, ~r/^[^\s]+$/, message: "must have no spaces")
    |> validate_length(:handle, min: 3, max: 20)
    |> unsafe_validate_unique(:handle, Habits.Repo)
    |> unique_constraint(:handle)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    |> maybe_hash_password()
  end

  defp maybe_hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
