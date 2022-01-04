defmodule Fitlog.Guardian do
  use Guardian, otp_app: :fitlog

  alias Fitlog.Users

  def subject_for_token(%{id: id}, _claims), do: {:ok, to_string(id)}
  def subject_for_token(_, _), do: {:error, :reason_for_error}

  def resource_from_claims(%{"sub" => id}) do
    {:ok, Users.get_user!(id)}
  end

  def resource_from_claims(_claims), do: {:error, :reason_for_error}
end
