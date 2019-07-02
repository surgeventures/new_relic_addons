# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :new_relic_sandbox,
  ecto_repos: [NewRelicSandbox.Repo]

config :new_relic_sandbox_web,
  ecto_repos: [NewRelicSandbox.Repo],
  generators: [context_app: :new_relic_sandbox]

# Configures the endpoint
config :new_relic_sandbox_web, NewRelicSandboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7+Zo8uFRTBVCouzPIrHrXUL762OjA4txJYDv8Odj73E61YrYxWdMuD0sHe8nHCay",
  render_errors: [view: NewRelicSandboxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NewRelicSandboxWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :new_relic_sandbox_web, NewRelicSandboxWeb.Endpoint,
  instrumenters: [NewRelic.Phoenix.Instrumenter]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :sasl, sasl_error_logger: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
