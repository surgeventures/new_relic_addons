defmodule NewRelicAddons.MixProject do
  use Mix.Project

  @name "NewRelicAddons"
  @description "Builds on top of New Relic's Agent to provide Ecto support and decorators"
  @github_url "https://github.com/surgeventures/new_relic_addons"

  def project do
    [
      app: :new_relic_addons,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: @name,
      description: @description,
      package: [
        maintainers: ["Karol Słuszniak"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url
        }
      ],
      docs: [
        main: @name,
        source_url: @github_url
      ]
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
