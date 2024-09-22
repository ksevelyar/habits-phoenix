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
            select: %{
              id: m.id,
              value_integer: m.value_integer,
              value_float: m.value_float,
              value_bool: m.value_bool,
              updated_at: m.updated_at,
              chain: c
            }

        Repo.all(query)

      error ->
        error
    end
  end

  def history(user_id) do
    two_weeks_ago = Date.utc_today() |> Date.add(-14)

    query =
      from m in Metric,
        join: c in assoc(m, :chain),
        where: m.date >= ^two_weeks_ago,
        where: c.active == true,
        where: c.user_id == ^user_id,
        order_by: [asc: m.date, asc: c.id],
        preload: [:chain]

    Repo.all(query)
  end

  def upsert(chain, attrs) do
    metric_changeset = Metric.changeset(chain, attrs)

    metric =
      Repo.insert(
        metric_changeset,
        on_conflict: {:replace, [:value_bool, :value_integer, :value_float, :updated_at]},
        conflict_target: [:chain_id, :date],
        returning: true
      )

    case metric do
      {:ok, metric} ->
        {:ok, Repo.preload(metric, :chain)}

      {:error, changeset} ->
        {:error, changeset}
    end
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
