defmodule Fitlog.Users.ErrorHandler do
  import Plug.Conn
  use FitlogWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(401)
    |> json(%{message: to_string(type)})
  end
end
