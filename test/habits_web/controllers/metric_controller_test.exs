defmodule HabitsWeb.MetricControllerTest do
  use HabitsWeb.ConnCase

  import Habits.Factory

  setup %{conn: conn} do
    user = insert!(:user)
    conn = conn |> init_test_session([]) |> log_in_user(user)
    chain = insert!(:chain, user: user)

    %{conn: conn, user: user, chain: chain}
  end

  describe "index" do
    test "lists all metrics", %{conn: conn, chain: chain} do
      insert!(:metric, chain: chain)

      conn = get(conn, ~p"/metrics?date=2024-09-07")

      assert [
               %{"id" => _, "chain" => "elixir", "chain_id" => _, "value" => _}
             ] = json_response(conn, 200)
    end
  end

  describe "create metric" do
    test "renders metric when data is valid", %{conn: conn, chain: chain} do
      metric_attrs = %{
        "value" => "42",
        "date" => "2024-09-07",
        "chain_id" => chain.id
      }

      conn = post(conn, ~p"/metrics", metric: metric_attrs)
      assert %{"id" => _id} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, chain: chain} do
      metric_attrs = %{"value" => "", "chain_id" => chain.id}

      conn = post(conn, ~p"/metrics", metric: metric_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update metric" do
    test "renders metric when data is valid", %{conn: conn, chain: chain} do
      metric = insert!(:metric, chain: chain)
      id = metric.id

      update_attrs = %{
        "value" => "42",
        "date" => "2024-09-07",
        "chain_id" => chain.id
      }

      conn = post(conn, ~p"/metrics/", metric: update_attrs)

      assert %{"id" => ^id, "updated_at" => _, "value" => 42} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, chain: chain} do
      insert!(:metric, chain: chain)
      metric_attrs = %{"value" => "", "chain_id" => chain.id}

      conn = post(conn, ~p"/metrics/", metric: metric_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete metric" do
    test "deletes chosen metric", %{conn: conn, chain: chain} do
      metric = insert!(:metric, chain: chain)

      conn = delete(conn, ~p"/metrics/#{metric.id}")
      assert response(conn, 204)
    end
  end
end
