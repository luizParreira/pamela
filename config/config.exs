# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pamela, ecto_repos: [Pamela.Repo]

# Configures the endpoint
config :pamela, PamelaWeb.Endpoint,
  url: [host: "dev"],
  secret_key_base: "XVurpsSlWBXqedTs+a4q9q94t9aFQKvRrM5ocecxguEyseaufyCDfnouUaRKDbYE",
  render_errors: [view: PamelaWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Pamela.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :nadia, token: System.get_env("TELEGRAM_TOKEN")
config :pamela, :bot_token, System.get_env("TELEGRAM_TOKEN")

config :pamela, :allowed_user, System.get_env("ALLOWED_USER")

config :binance,
  api_key: System.get_env("API_KEY"),
  secret_key: System.get_env("SECRET_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
