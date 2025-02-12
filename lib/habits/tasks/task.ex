defmodule Habits.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :active, :boolean, default: false
    field :name, :string
    field :type, Ecto.Enum, values: [:integer]
    field :cron, :string
    field :recurring, :boolean, default: false
    field :user_id, :id
    field :notified_at, :utc_datetime_usec

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :type, :active, :cron, :recurring])
    |> validate_required([:name, :type, :active, :cron, :recurring])
  end
end
