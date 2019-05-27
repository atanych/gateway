use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gateway, GatewayWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :ex_unit, assert_receive_timeout: 400

# Configure your database
config :gateway, Gateway.Repo,
  username: "root",
  database: "gateway_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
