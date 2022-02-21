defmodule Fitlog.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :handle, :email, :avatar_url, :inserted_at]}

  schema "users" do
    field :email, :string
    field :avatar_url, :string
    field :handle, :string
    field :github_id, :integer
    has_many :reports, Fitlog.Reports.Report

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:handle, :email, :avatar_url, :github_id])
    |> validate_required([:handle, :email, :avatar_url, :github_id])
    |> validate_number(:github_id, greater_than: 0)
    |> validate_length(:handle, min: 3, max: 15)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:handle, ~r/^\w+$/)
    |> unique_constraint(:github_id)
    |> unique_constraint(:handle)
  end
end
