defmodule HabitsWeb.ChainOrderController do
  use HabitsWeb, :controller

  alias Habits.Chains

  action_fallback HabitsWeb.FallbackController

  def create(conn, %{"chain_id_1" => chain_id_1, "chain_id_2" => chain_id_2}) do
    Chains.swap_order(conn.assigns.current_user.id, chain_id_1, chain_id_2)

    conn
    |> put_status(:created)
    |> send_resp(:no_content, "")
  end
end
