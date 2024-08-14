defmodule Habits.Metrics do
  import Ecto.Query, warn: false
  alias Habits.Repo

  alias Habits.Metrics.Metric
  alias Habits.Chains.Chain

  def get_by_date(user_id, date) do
    case Date.from_iso8601(date) do
      {:ok, date} ->
        query =
          from c in Chain,
            left_join: m in Metric,
            on: m.chain_id == c.id and m.date == ^date,
            where: c.active == ^true,
            where: c.user_id == ^user_id,
            select: %{id: m.id, value: m.value, chain: c}

        Repo.all(query)

      error ->
        error
    end
  end

  def upsert(chain, attrs) do
    metric_changeset =
      chain
      |> Ecto.build_assoc(:metrics)
      |> Metric.changeset(attrs)

    Repo.insert(
      metric_changeset,
      on_conflict: {:replace, [:value, :updated_at]},
      conflict_target: [:chain_id, :date],
      returning: true
    )
  end

  def get_metric!(user_id, metric_id) do
    query =
      from m in Metric,
        join: c in Chain,
        on: m.chain_id == c.id,
        where: m.id == ^metric_id,
        where: c.user_id == ^user_id

    case Repo.one(query) do
      nil -> raise Ecto.NoResultsError, queryable: query
      result -> result
    end
  end

  def delete_metric(%Metric{} = metric) do
    Repo.delete(metric)
  end
end
