defmodule Habits.Metrics.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:value, :date, :chain, :updated_at]}
  schema "metrics" do
    field :value, :integer
    field :date, :date

    belongs_to :chain, Habits.Chains.Chain

    timestamps(type: :utc_datetime)
  end

  def changeset(chain, attrs) do
    chain
    |> cast(attrs, [:value, :chain_id, :date])
    |> validate_required([:value, :chain_id, :date])
  end
end
