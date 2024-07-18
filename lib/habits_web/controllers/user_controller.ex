defmodule HabitsWeb.UserController do
  use HabitsWeb, :controller

  alias Habits.Users
  alias Habits.Users.User
  alias HabitsWeb.Authentication

  action_fallback HabitsWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> Authentication.log_in(user)
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def show(conn, _params) do
    conn = Authentication.fetch_current(conn, [])

    if conn.assigns.current_user do
      render(conn, :show, user: conn.assigns.current_user)
    else
      send_resp(conn, :not_found, "")
    end
  end

  def update(conn, %{"user" => user_params}) do
    Authentication.fetch_current(conn, [])
    user = conn.assigns.current_user

    if user do
      with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
        render(conn, :show, user: user)
      end
    else
      send_resp(conn, :not_found, "")
    end
  end

  def delete(conn) do
    Authentication.fetch_current(conn, [])
    user = conn.assigns.current_user

    if user do
      with {:ok, %User{}} <- Users.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    else
      send_resp(conn, :not_found, "")
    end
  end
end
