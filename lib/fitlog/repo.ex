defmodule Fitlog.Repo do
  use Ecto.Repo,
    otp_app: :fitlog,
    adapter: Ecto.Adapters.Postgres
end
