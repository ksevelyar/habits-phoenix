defmodule HabitsWeb.MetricsHistoryController do
  use HabitsWeb, :controller

  alias Habits.Metrics

  action_fallback HabitsWeb.FallbackController

  def index(conn, _params) do
    metrics = Metrics.history(conn.assigns.current_user.id)

    render(conn, :index, %{metrics: metrics})
  end
end
