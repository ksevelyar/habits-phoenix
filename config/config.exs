# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :fitlog,
  ecto_repos: [Fitlog.Repo]

# Configures the endpoint
config :fitlog, FitlogWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FitlogWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Fitlog.PubSub,

config :fitlog, Fitlog.Users.Guardian,
  issuer: "fitlog",
  secret_key: "mix guardian.gen.secret"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
