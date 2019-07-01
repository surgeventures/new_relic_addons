# NewRelicAddons

Builds on top of [New Relic's Open Source Elixir Agent](https://github.com/newrelic/elixir_agent) to
provide missing monitoring capabilities.

## Features

- `NewRelicAddons.Decorators` - provides stackable function decoration solution based on
  battle-proven `Decorator` library, with sane defaults and more configurability

- `NewRelicAddons.Ecto` - provides Ecto introspection with best database monitoring solution that's
  possible with current API of the `NewRelic` library

## Notes

This library uses private APIs of `NewRelic` library, i.e. it calls modules without `@moduledoc`. It
also includes a set of overrides built on top of `NewRelic` library in `NewRelicAddons.Reporting`
module. It's considered a minimal set needed for implementing functionalities that we were chasing
after, but still - that's not great.

This means that all updates of base `:new_relic_agent` package, even between patch versions, should
be thoroughly reviewed for breaking changes within functions that are called or overridden.

The long-term plan is to fill an issue in agent's repo and count on its API getting extended and
refined so that in the future we'd only need to rely on public APIs without sacrificing key NR
integration perks.
