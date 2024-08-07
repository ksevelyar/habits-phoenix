defmodule HabitsWeb.SessionController do
  use HabitsWeb, :controller

  alias Habits.Users
  alias HabitsWeb.Authentication

  action_fallback HabitsWeb.FallbackController

  def create(conn, %{"user" => params}) do
    %{"email" => email, "password" => password} = params

    if user = Users.get_by_email_and_password(email, password) do
      conn
      |> Authentication.log_in(user, params)
      |> put_status(:created)
      |> render(:show, user: user)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :error, error_message: "Invalid email or password")
    end
  end

  def show(conn, _params) do
    if conn.assigns.current_user do
      render(conn, :show, user: conn.assigns.current_user)
    else
      send_resp(conn, :not_found, "")
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.log_out()
    |> send_resp(:no_content, "")
  end
end
