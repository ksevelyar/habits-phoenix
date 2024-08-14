defmodule HabitsWeb.MetricJSON do
  def index(%{metrics: metrics}) do
    for(metric <- metrics, do: data(metric))
  end

  def show(%{metric: metric}) do
    data(metric)
  end

  def create(%{metric: metric}) do
    %{value: metric.value, updated_at: metric.updated_at, id: metric.id}
  end

  defp data(metric) do
    %{
      id: metric.id,
      value: metric.value,
      chain: metric.chain.name,
      chain_id: metric.chain.id
    }
  end
end
