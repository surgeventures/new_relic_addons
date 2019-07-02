defmodule NewRelicSandbox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      NewRelicSandbox.Repo,
      NewRelicSandbox.Accounts.OldUserPeriodicDeletion
    ]

    :telemetry.attach(
      "new-relic-sandbox-ecto",
      [:new_relic_sandbox, :repo, :query],
      &NewRelicAddons.Ecto.handle_event/4,
      []
    )

    Supervisor.start_link(children, strategy: :one_for_one, name: NewRelicSandbox.Supervisor)
  end
end
