defmodule HabitsWeb.MetricJSON do
  def index(%{metrics: metrics}) do
    for(metric <- metrics, do: data(metric))
  end

  def show(%{metric: metric}) do
    data(metric)
  end

  def create(%{metric: metric}) do
    data(metric)
  end

  defp data(metric) do
    %{
      id: metric.id,
      value: build_value(metric, metric.chain),
      chain: metric.chain.name,
      chain_id: metric.chain.id,
      updated_at: metric.updated_at
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
