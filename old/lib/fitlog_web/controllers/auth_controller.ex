defmodule FitlogWeb.AuthController do
  use FitlogWeb, :controller

  alias Fitlog.Users.Guardian

  plug Ueberauth

  defp redirect_to_front(handle) do
    "#{System.get_env("FRONT")}/#{handle}"
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    {:ok, user} =
      Fitlog.Users.upsert(%{
        handle: auth.info.nickname,
        email: auth.info.email,
        avatar_url: auth.info.image,
        github_id: auth.extra.raw_info.user["id"]
      })

    Guardian.Plug.sign_in(conn, user)
    |> redirect(external: redirect_to_front(user.handle))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_status(401)
    |> json(%{message: "🐗"})
  end
end
