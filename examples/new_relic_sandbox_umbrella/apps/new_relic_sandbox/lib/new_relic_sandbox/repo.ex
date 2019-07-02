defmodule NewRelicSandbox.Repo do
  use Ecto.Repo,
    otp_app: :new_relic_sandbox,
    adapter: Ecto.Adapters.Postgres
end
