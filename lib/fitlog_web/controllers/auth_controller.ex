defmodule FitlogWeb.AuthController do
  use FitlogWeb, :controller

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    {:ok, user} =
      Fitlog.Users.upsert(%{
        handle: auth.info.nickname,
        email: auth.info.email,
        avatar_url: auth.info.image
      })

    json(conn, user)
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_status(401)
    |> json(%{message: "🐗"})
  end
end
