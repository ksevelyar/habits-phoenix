defmodule HabitsWeb.MetricsHistoryJSON do
  def index(%{metrics: metrics}) do
    chains = for metric <- metrics, uniq: true, do: metric.chain

    metrics = Enum.map(metrics, fn metric -> data(metric) end)

    weeks = split_by_sundays(metrics)

    sprints =
      Enum.map(weeks, fn week ->
        %{
          total:
            Enum.map(chains, fn chain -> {chain.id, calc_total(chain, week)} end) |> Map.new(),
          week: group_by_date_and_chain(week)
        }
      end)

    %{chains: chains, sprints: sprints}
  end

  def split_by_sundays(metrics) do
    Enum.chunk_by(metrics, fn metric ->
      Date.beginning_of_week(metric.date)
    end)
  end

  defp group_by_date_and_chain(metrics) do
    Enum.reduce(metrics, %{}, fn metric, acc ->
      date = metric.date
      chain_id = metric.chain_id

      Map.update(acc, date, %{chain_id => metric}, fn chains ->
        Map.put(chains, chain_id, metric)
      end)
    end)
  end

  defp calc_total(%{name: "weight", id: id}, week) do
    values =
      week
      |> Stream.filter(fn metric -> metric.chain_id == id end)
      |> Stream.map(fn metric -> metric.value end)

    (Enum.sum(values) / Enum.count(values)) |> Float.ceil(1)
  end

  defp calc_total(chain, week) do
    week
    |> Stream.filter(fn metric -> metric.chain_id == chain.id end)
    |> Stream.map(fn metric -> metric.value end)
    |> Enum.sum()
  end

  defp data(metric) do
    %{
      date: metric.date,
      id: metric.id,
      value: build_value(metric, metric.chain),
      chain: metric.chain.name,
      chain_id: metric.chain.id
    }
  end

  defp build_value(metric, chain) do
    case chain.type do
      :integer -> metric.value_integer
      :float -> metric.value_float
      :bool -> metric.value_bool
    end
  end
end
