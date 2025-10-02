defmodule Habits.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :active, :boolean, default: false
    field :name, :string
    field :cron, :string
    field :notified_at, :utc_datetime_usec

    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :active, :cron])
    |> validate_required([:name, :active, :cron])
  end
end
