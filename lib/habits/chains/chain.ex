defmodule Habits.Chains.Chain do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :id]}
  schema "chains" do
    field :active, :boolean, default: true
    field :name, :string
    field :type, Ecto.Enum, values: [:integer, :float, :boolean]
    field :description, :string

    belongs_to :user, Habits.Users.User
    has_many :metrics, Habits.Metrics.Metric

    timestamps(type: :utc_datetime)
  end

  def changeset(chain, attrs) do
    chain
    |> cast(attrs, [:name, :type, :active, :description])
    |> validate_required([:name, :type, :active])
  end
end
