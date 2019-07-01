defmodule NewRelicAddons.MixProject do
  use Mix.Project

  def project do
    [
      app: :new_relic_addons,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:decorator, "~> 1.3.0"},
      {:ex_doc, "~> 0.20", only: :dev, runtime: false},

      # Read notes in README.md when upgrading new_relic_agent
      {:new_relic_agent, "1.9.11"}
    ]
  end
end
