defmodule HabitsWeb.MetricsHistoryJSON do
  def index(%{metrics: metrics}) do
    chains = for metric <- metrics, uniq: true, do: metric.chain

    metrics =
      Enum.reduce(metrics, %{}, fn metric, acc ->
        date = metric.date
        chain_id = metric.chain_id

        Map.update(acc, date, %{chain_id => data(metric)}, fn chains ->
          Map.put(chains, chain_id, data(metric))
        end)
      end)

    %{chains: chains, metrics: metrics}
  end

  defp data(metric) do
    %{
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
