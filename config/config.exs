# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lukimat,
  ecto_repos: [Lukimat.Repo]

# Configures the endpoint
config :lukimat, LukimatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3Z3vzcQ8DGhm2AH9L0fJKuEahAVDTv7ufL6gkh19ps8Ua3updcgsu8k44QZ5PUO5",
  render_errors: [view: LukimatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lukimat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :lukimat, LukimatWeb.Guardian,
 issuer: "Lukimat.#{Mix.env}",
 secret_key: "SuPerseCret_aBraCadabrA"

config :arc,
  storage: Arc.Storage.Local

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
