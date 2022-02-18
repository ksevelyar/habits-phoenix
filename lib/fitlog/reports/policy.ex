defmodule Fitlog.Reports.Policy do
  def authorize(action, %{id: user_id} = _user, %{user_id: user_id} = _report)
      when action in [:update, :delete],
      do: :ok

  def authorize(_action, _user, _report), do: :error
end
