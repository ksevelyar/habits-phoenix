defmodule Habits.Metrics.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  @value_fields [:value_integer, :value_bool, :value_float]

  schema "metrics" do
    field :value_integer, :integer
    field :value_float, :float
    field :value_bool, :boolean
    field :date, :date

    belongs_to :chain, Habits.Chains.Chain

    timestamps(type: :utc_datetime)
  end

  def changeset(chain, attrs) do
    chain
    |> Ecto.build_assoc(:metrics)
    |> cast(attrs, [:chain_id, :date])
    |> cast_value(chain, attrs)
    |> validate_value()
  end

  def validate_value(changeset) do
    filled_fields =
      Enum.filter(@value_fields, fn field ->
        get_field(changeset, field) not in [nil, ""]
      end)

    case filled_fields do
      [] -> add_error(changeset, :value, "At least one field must be filled in")
      [_] -> changeset
      _ -> add_error(changeset, :value, "Only one field can be filled in")
    end
  end

  defp cast_value(changeset, chain, attrs) do
    value = attrs["value"]

    case chain.type do
      :integer ->
        case Integer.parse(value) do
          {value, _} ->
            put_change(changeset, :value_integer, value)

          :error ->
            add_error(changeset, :value_integer, "Can't parse")
        end

      :float ->
        case Float.parse(value) do
          {value, _} ->
            put_change(changeset, :value_float, value)

          :error ->
            add_error(changeset, :value_float, "Can't parse")
        end

      :bool ->
        put_change(changeset, :value_bool, value == "true")
    end
  end
end
