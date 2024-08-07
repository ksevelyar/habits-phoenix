defmodule HabitsWeb.SessionControllerTest do
  use HabitsWeb.ConnCase, async: true

  import Habits.Factory

  setup do
    %{user: insert!(:user, password: "secure🐗password")}
  end

  describe "POST /sessions" do
    test "logs the user in", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session([])
        |> post(~p"/sessions/", %{
          "user" => %{"email" => user.email, "password" => "secure🐗password"}
        })

      assert get_session(conn, :user_token)

      response = json_response(conn, 201)
      assert %{"handle" => user.handle, "email" => user.email, "id" => user.id} == response
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn = init_test_session(conn, [])

      conn =
        post(conn, ~p"/sessions", %{
          "user" => %{
            "email" => user.email,
            "password" => "secure🐗password",
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_habits_web_user_remember_me"]
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session([])
        |> post(~p"/sessions", %{
          "user" => %{"email" => user.email, "password" => "invalid_password"}
        })

      assert %{"errors" => _} = json_response(conn, 200)
    end
  end

  describe "GET /sessions/" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> init_test_session([]) |> log_in_user(user) |> get(~p"/sessions")

      response = json_response(conn, 200)
      assert %{"handle" => user.handle, "email" => user.email, "id" => user.id} == response
    end
  end

  describe "DELETE /sessions" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> init_test_session([]) |> log_in_user(user) |> delete(~p"/sessions")

      refute get_session(conn, :user_token)
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = conn |> init_test_session([]) |> delete(~p"/sessions")

      refute get_session(conn, :user_token)
    end
  end
end
