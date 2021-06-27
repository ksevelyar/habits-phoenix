# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fitlog,
  ecto_repos: [Fitlog.Repo]

# Configures the endpoint
config :fitlog, FitlogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uwnRyT9hj+L23POR+eBB8wpRHd1uuy0eDow4ZZCL9fKvZ2RFqUpzP6neR+9Sovq1",
  render_errors: [view: FitlogWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Fitlog.PubSub,
  live_view: [signing_salt: "P+aYM0lr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
