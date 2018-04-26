# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fire_engine,
  ecto_repos: [FireEngine.Repo]

# Configures the endpoint
config :fire_engine, FireEngineWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SpMnXtjBC/zZws97GmsZQTIVcN0ESFTshJUsnPo7BkTkUrEy7wDazD/2JD+jaYEr",
  render_errors: [view: FireEngineWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FireEngine.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Ueberauth CAS Settings
config :ueberauth, Ueberauth,
  providers: [cas: {Ueberauth.Strategy.CAS, [
    base_url: "http://sso.cs2n.org",
    request_path: "/login",
    callback_path: "/auth/cas/callback",
  ]}]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
