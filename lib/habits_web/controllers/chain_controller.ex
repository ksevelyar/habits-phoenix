defmodule HabitsWeb.ChainController do
  use HabitsWeb, :controller

  alias Habits.Chains

  action_fallback HabitsWeb.FallbackController

  def index(conn, _params) do
    chains = Chains.list_chains(conn.assigns.current_user.id)
    render(conn, :index, chains: chains)
  end

  def create(conn, %{"chain" => chain_params}) do
    with {:ok, chain} <- Chains.create_chain(conn.assigns.current_user, chain_params) do
      conn
      |> put_status(:created)
      |> render(:show, chain: chain)
    end
  end

  def update(conn, %{"id" => id, "chain" => chain_params}) do
    chain = Chains.get_chain!(conn.assigns.current_user.id, id)

    with {:ok, chain} <- Chains.update_chain(chain, chain_params) do
      render(conn, :show, chain: chain)
    end
  end

  def delete(conn, %{"id" => id}) do
    chain = Chains.get_chain!(conn.assigns.current_user.id, id)

    with {:ok, _chain} <- Chains.delete_chain(chain) do
      send_resp(conn, :no_content, "")
    end
  end
end
