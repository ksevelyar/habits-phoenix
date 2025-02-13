defmodule Habits.Chains.Chain do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Habits.Repo

  @derive {Jason.Encoder, only: [:name, :id, :type, :aggregate]}
  schema "chains" do
    field :active, :boolean, default: true
    field :name, :string
    field :type, Ecto.Enum, values: [:integer, :float, :boolean]
    field :aggregate, Ecto.Enum, values: [:sum, :avg]
    field :description, :string
    field :order, :integer

    belongs_to :user, Habits.Users.User
    has_many :metrics, Habits.Metrics.Metric

    timestamps(type: :utc_datetime)
  end

  def changeset(chain, attrs) do
    chain
    |> cast(attrs, [:name, :type, :active, :description, :aggregate, :order])
    |> put_order_for_new_record()
    |> validate_required([:name, :type, :active, :aggregate])
  end

  defp put_order_for_new_record(changeset) do
    if changeset.data.id do
      changeset
    else
      order = Repo.one(from c in __MODULE__, select: count(c.id))
      put_change(changeset, :order, order)
    end
  end
end
