# NewRelicAddons

[![license](https://img.shields.io/github/license/surgeventures/new_relic_addons.svg)](https://github.com/surgeventures/new_relic_addons/blob/master/LICENSE.md)
[![build status](https://img.shields.io/circleci/project/github/surgeventures/new_relic_addons/master.svg)](https://circleci.com/gh/surgeventures/surgeventures/new_relic_addons/tree/master)
[![Hex version](https://img.shields.io/hexpm/v/new_relic_addons.svg)](https://hex.pm/packages/new_relic_addons)

Builds on top of [New Relic's Open Source Elixir Agent](https://github.com/newrelic/elixir_agent) to
provide Ecto support and decorators.

## Features

- `NewRelicAddons.Ecto` - provides Ecto introspection with best database monitoring solution that's
  possible with current API of the `NewRelic` library

- `NewRelicAddons.Decorators` - provides stackable function decoration solution based on
  battle-proven `Decorator` library, with sane defaults and more configurability

## Usage

The docs can be found at [https://hexdocs.pm/new_relic_addons](https://hexdocs.pm/new_relic_addons).

They include usage information and examples for all available features.

## Example

Sample Phoenix + Ecto application may be found in
[examples/new_relic_sandbox_umbrella](https://github.com/surgeventures/new_relic_addons/tree/master/examples/new_relic_sandbox_umbrella).

Check out its README.md for more information.

## Notes

This library uses private APIs of `NewRelic` library, i.e. it calls modules without `@moduledoc`. It
also includes a set of overrides built on top of `NewRelic` library in `NewRelicAddons.Reporting`
module. It's considered a minimal set needed for implementing functionalities that we were chasing
after, but still - that's not great.

This means that all updates of base `:new_relic_agent` package, even between patch versions, should
be thoroughly reviewed for breaking changes within functions that are called or overridden.

The long-term plan is to [fill an issue in agent's
repo](https://github.com/newrelic/elixir_agent/issues/122) and count on its API getting extended and
refined so that in the future we'd only need to rely on public APIs without sacrificing key NR
integration perks.
