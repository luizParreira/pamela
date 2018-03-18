use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pamela, PamelaWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :pamela, Pamela.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pamela_bot_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

config :pamela, :allowed_user, "1"

config :pamela, :telegram_client, NadiaMock
config :pamela, :binance_client, BinanceMock
