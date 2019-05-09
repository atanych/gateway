# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gateway,
  ecto_repos: [Gateway.Repo]

# Configures the endpoint
config :gateway, GatewayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "f/QVsdXbmfNEPPMWjU3hPkLKfvYpvRYPD0PmRpzF23BaIbBeJ7/Zd1Ir45FOriQF",
  render_errors: [view: GatewayWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Gateway.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$date $time $metadata[$level] $message\n",
  metadata: [:request_id, :transport]

# Use custom reporter because errors not sending in rollbar (see RollbaxReporter method for "Common error")
config :rollbax,
       access_token: "f4207c6bf02b4f57b5eae8141cab49c3",
       environment: System.get_env("MIX_ENV"),
       enabled: System.get_env("ENABLE_ROLLBAR") == "true",
         #       reporters: [Rollbar.Reporter], # For use in rollbax custom reporter
       enable_crash_reports: true

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "logger.exs"

case Mix.env() do
  :test -> import_config "test.exs"
  :dev -> import_config "dev.exs"
  _ -> import_config "server.exs"
end
