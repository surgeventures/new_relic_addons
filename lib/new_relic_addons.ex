defmodule NewRelicAddons do
  @moduledoc """
  Builds on top of `NewRelic` agent for Elixir to provide missing monitoring capabilities.

  ## Features

  - `NewRelicAddons.Decorators` - provides stackable function decoration solution based on
    battle-proven `Decorator` library, with sane defaults and more configurability

  - `NewRelicAddons.Ecto` - provides Ecto introspection with best database monitoring solution
    that's possible with current API of the `NewRelic` library

  ## Notes

  This library uses private APIs of `NewRelic` library, i.e. it calls modules without `@moduledoc`.
  It also includes a set of overrides in `NewRelicAddons.Reporting` module. It's considered a
  minimal set required for implementing required functionalities, but still.

  This means that all updates of base `:new_relic_agent` package, even between patch versions,
  should be thoroughly reviewed for breaking changes within functions that are called and that are
  overridden.

  """
end
