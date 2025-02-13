defmodule HabitsWeb.ChainControllerTest do
  use HabitsWeb.ConnCase

  import Habits.Factory

  setup %{conn: conn} do
    user = insert!(:user)
    conn = conn |> init_test_session([]) |> log_in_user(user)

    %{user: user, conn: conn}
  end

  describe "index" do
    test "lists all chains", %{conn: conn, user: user} do
      insert!(:chain, user: user)

      conn = get(conn, ~p"/chains")

      assert [
               %{"active" => true, "id" => _, "name" => "elixir", "type" => "integer"}
             ] = json_response(conn, 200)
    end
  end

  describe "create chain" do
    test "renders chain when data is valid", %{conn: conn} do
      chain_attrs = %{
        "name" => "rust",
        "active" => "true",
        "type" => "integer",
        "description" => "pomodoro",
        "aggregate" => "sum"
      }

      conn = post(conn, ~p"/chains", chain: chain_attrs)
      assert %{"id" => _id} = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      chain_attrs = %{
        "active" => "true",
        "type" => "integer"
      }

      conn = post(conn, ~p"/chains", chain: chain_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chain" do
    test "renders chain when data is valid", %{conn: conn, user: user} do
      chain = insert!(:chain, user: user)
      id = chain.id

      update_attrs = %{
        "active" => "false",
        "name" => "pullups"
      }

      conn = put(conn, ~p"/chains/#{id}", chain: update_attrs)

      assert %{
               "id" => ^id,
               "active" => false,
               "name" => "pullups",
               "type" => "integer"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      chain = insert!(:chain, user: user)
      chain_attrs = %{"name" => ""}

      conn = put(conn, ~p"/chains/#{chain.id}", chain: chain_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chain" do
    test "deletes chosen chain", %{conn: conn, user: user} do
      chain = insert!(:chain, user: user)

      conn = delete(conn, ~p"/chains/#{chain.id}")
      assert response(conn, 204)
    end
  end
end
