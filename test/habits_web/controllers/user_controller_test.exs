defmodule HabitsWeb.UserControllerTest do
  use HabitsWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST /users/" do
    test "creates account and logs the user in", %{conn: conn} do
      conn =
        conn
        |> init_test_session([])
        |> post(~p"/users", %{
          "user" => %{email: "some@email", password: "secure🐗password", handle: "=user="}
        })

      assert get_session(conn, :user_token)
      assert %{"id" => _id, "email" => "some@email", "handle" => "=user="} = json_response(conn, 201)
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/users", %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
