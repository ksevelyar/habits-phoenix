defmodule HabitsWeb.MetricController do
  use HabitsWeb, :controller

  alias Habits.Metrics
  alias Habits.Chains

  action_fallback HabitsWeb.FallbackController

  def index(conn, params) do
    metrics = Metrics.get_by_date(conn.assigns.current_user.id, params["date"])
    render(conn, :index, metrics: metrics)
  end

  def create(conn, %{"metric" => metric_params}) do
    chain = Chains.get_chain!(conn.assigns.current_user.id, metric_params["chain_id"])

    with {:ok, metric} <- Metrics.upsert(chain, metric_params) do
      render(conn, :create, metric: metric)
    end
  end

  def delete(conn, %{"id" => id}) do
    metric = Metrics.get_metric!(conn.assigns.current_user.id, id)

    with {:ok, _metric} <- Metrics.delete_metric(metric) do
      send_resp(conn, :no_content, "")
    end
  end
end
