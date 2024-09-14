defmodule HabitsWeb.MetricsHistoryJSON do
  def index(%{metrics: metrics}) do
    chains = for metric <- metrics, uniq: true, do: metric.chain

    metrics =
      Enum.reduce(metrics, %{}, fn metric, acc ->
        date = metric.date
        chain_id = metric.chain_id

        Map.update(acc, date, %{chain_id => metric}, fn chains ->
          Map.put(chains, chain_id, metric)
        end)
      end)

    %{chains: chains, metrics: metrics}
  end
end
