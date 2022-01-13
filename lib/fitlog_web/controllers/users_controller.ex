defmodule FitlogWeb.UsersController do
  use FitlogWeb, :controller

  alias Fitlog.Users.Guardian
  alias Fitlog.Users

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    json(conn, user)
  end
end
