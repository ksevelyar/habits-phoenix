defmodule Fitlog.Users.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :fitlog,
    error_handler: Fitlog.Users.ErrorHandler,
    module: Fitlog.Users.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token and validate it
  # plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: false
end
