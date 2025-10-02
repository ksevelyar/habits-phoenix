defmodule HabitsWeb.TaskJSON do
  alias Habits.Tasks.Task

  @doc """
  Renders a list of tasks.
  """
  def index(%{tasks: tasks}) do
    for task <- tasks, do: data(task)
  end

  @doc """
  Renders a single task.
  """
  def show(%{task: task}) do
    data(task)
  end

  defp data(%Task{} = task) do
    %{
      id: task.id,
      name: task.name,
      active: task.active,
      cron: task.cron
    }
  end
end
