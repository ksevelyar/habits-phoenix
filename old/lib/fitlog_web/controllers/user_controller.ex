defmodule FitlogWeb.UserController do
  use FitlogWeb, :controller

  alias Fitlog.Users.Guardian

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    json(conn, user)
  end
end
