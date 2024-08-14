defmodule HabitsWeb.SessionJSON do
  def show(%{user: user}) do
    %{id: user.id, email: user.email, handle: user.handle}
  end

  def error(params) do
    %{errors: params.conn.assigns[:error_message]}
  end
end
