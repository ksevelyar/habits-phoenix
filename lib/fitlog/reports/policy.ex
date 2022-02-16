defmodule Fitlog.Reports.Policy do
  def authorize(:update, %{id: user_id} = _user, %{user_id: user_id} = _report), do: :ok
  def authorize(:update, _user, _report), do: :error
end
