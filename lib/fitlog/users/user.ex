defmodule Fitlog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :handle, :email, :avatar_url, :inserted_at]}

  schema "users" do
    field :email, :string
    field :avatar_url, :string
    field :handle, :string
    has_many :reports, Fitlog.Reports.Report

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:handle, :email, :avatar_url])
    |> validate_required([:handle, :email, :avatar_url])
    |> validate_length(:handle, min: 3, max: 15)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:handle, ~r/^\w+$/)
    |> unique_constraint(:email)
    |> unique_constraint(:handle)
  end
end
