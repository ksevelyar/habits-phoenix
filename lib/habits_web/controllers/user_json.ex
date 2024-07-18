defmodule HabitsWeb.UserJSON do
  alias Habits.Users.User

  def index(%{users: users}) do
    %{data: for(user <- users, do: user(user))}
  end

  def show(%{user: user}) do
    user(user)
  end

  defp user(%User{} = user) do
    %{
      id: user.id,
      handle: user.handle,
      email: user.email,
      confirmed_at: user.confirmed_at
    }
  end
end
