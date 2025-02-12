defmodule HabitsWeb.TaskControllerTest do
  use HabitsWeb.ConnCase

  import Habits.Factory
  alias Habits.Tasks.Task

  @update_attrs %{
    active: false,
    name: "some updated name",
    type: :integer,
    cron: "some updated cron",
    recurring: false
  }
  @invalid_attrs %{active: nil, name: nil, type: nil, cron: nil, recurring: nil}

  setup %{conn: conn} do
    user = insert!(:user)
    conn = conn |> init_test_session([]) |> log_in_user(user)

    %{user: user, conn: conn}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, ~p"/tasks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn, user: user} do
      create_attrs = %{
        user_id: user.id,
        active: true,
        name: "some name",
        type: :integer,
        cron: "some cron",
        recurring: true
      }

      conn = post(conn, ~p"/tasks", task: create_attrs)

      assert data = json_response(conn, 201)["data"]
      assert %{
               "id" => _,
               "active" => true,
               "cron" => "some cron",
               "name" => "some name",
               "recurring" => true,
               "type" => "integer"
             } = data
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/tasks", task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      conn = put(conn, ~p"/tasks/#{task}", task: @update_attrs)
      assert data = json_response(conn, 200)["data"]

      assert %{
               "id" => ^id,
               "active" => false,
               "cron" => "some updated cron",
               "name" => "some updated name",
               "recurring" => false,
               "type" => "integer"
             } = data
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/tasks/#{task}", task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, ~p"/tasks/#{task}")
      assert response(conn, 204)

      conn = get(conn, ~p"/tasks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  defp create_task(_) do
    task = insert!(:task)
    %{task: task}
  end
end
