defmodule HabitsWeb.SessionJSON do
  def show(%{user: user}) do
    %{id: user.id, email: user.email, handle: user.handle}
  end

  def error(_) do
    %{errors: "🐗"}
  end
end
