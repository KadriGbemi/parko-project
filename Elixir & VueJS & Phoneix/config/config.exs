# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :parko,
  ecto_repos: [Parko.Repo]
config :parko, gmaps_api_key: "AIzaSyBKQSIlYg8n0VzMvlNziPsPcyu1V56IB60"

config :guardian, Guardian,
issuer: "Parko",
ttl: { 30, :days },
allowed_drift: 2000,
secret_key: "wdLU4I7b/LYQl0/0pjs4ZwLXgv+WDxcOOdYufJr0xPl8736RrqMnv74BwUu1neFQ",
serializer: Parko.GuardianSerializer

# Configures the endpoint
config :parko, Parko.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "U8JC/0XDB+QVMFBk0NxdiFM8+iiq0RrOCBzDkdkBx40Su5ARha9KCJlLuV9kGFIY",
  render_errors: [view: Parko.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Parko.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
