defmodule NewRelicAddons.Decorators do
  @moduledoc """
  Provides easy-to-use stackable decorators for the official New Relic library.

  ## Features

  - decorators are stackable with others e.g. from other libraries
  - allows to hide args in event tracer via `hide_args` option
  - includes transaction tracer with process-based scoping and customizable category name

  ## Usage

  You must first include decorators in your module:

      use NewRelicAddons.Decorators

  Then you can start decorating specific functions:

      @decorate new_relic_event()
      defp some_long_operation do
        # ...
      end

      @decorate new_relic_event()
      defp other_long_operation do
        # ...
      end

  ...or the entire module:

      @decorate_all new_relic_event()

      # ...

  ...or if you expect vulnerable function attributes:

      @decorate new_relic_event(hide_args: true)
      defp change_password(user, new_password) do
        # ...
      end

  If these functions are called within Phoenix web request processes and you've already configured
  `NewRelicPhoenix`, then you're good to go - decorated calls will now appear within your web
  transactions.

  If you however want to trace functions from outside of Phoenix flow (e.g. background jobs or
  any GenServers), you'll also have to wrap the processing function in a transaction:

      @decorate new_relic_transaction()
      defp process do
        some_long_operation()
        other_long_operation()
      end

      @decorate new_relic_event()
      defp some_long_operation do
        # ...
      end

      @decorate new_relic_event()
      defp other_long_operation do
        # ...
      end

  You may also specify a custom category:

      @decorate new_relic_transaction("RPC")
      defp process_rpc_call(request) do
        # ...
      end

  Keep in mind that the function wrapped in `transaction` decorator will be called on separate
  process in order to control the lifecycle of the transaction. The process is spawned via
  `Task.async` and awaited upon for infinity - thus not changing the initial behavior. Even though
  the timeout is set to `:infinity`, the transaction function should not be long-running or you'll
  run into trouble (see `NewRelic.start_transaction/2`).
  """

  use Decorator.Define,
    new_relic_transaction: 0,
    new_relic_transaction: 1,
    new_relic_event: 0,
    new_relic_event: 1

  def new_relic_transaction(opts \\ [], body, %{module: mod, name: func, arity: arity}) do
    category_name = Keyword.get(opts, :category_name, "Background process")
    name = "#{inspect(mod)}.#{func}/#{arity}"

    unless is_binary(category_name), do: raise(ArgumentError, "expected category name string")

    start_new_relic_transaction(Mix.env(), category_name, name, body)
  end

  # For test env we are not creating another tasks, as Ecto in shared mode is unable to close them.
  defp start_new_relic_transaction(:test, category_name, name, body) do
    quote do
      fn ->
        NewRelic.start_transaction(unquote(category_name), unquote(name))
        unquote(body)
      end
    end
  end

  defp start_new_relic_transaction(_, category_name, name, body) do
    quote do
      fn ->
        NewRelic.start_transaction(unquote(category_name), unquote(name))
        unquote(body)
      end
      |> Task.async()
      |> Task.await(:infinity)
    end
  end

  def new_relic_event(opts \\ [], body, %{module: mod, name: func, args: args}) do
    name = Keyword.get(opts, :name, func)
    args = if opts[:hide_args], do: List.duplicate(:hidden, length(args)), else: args

    unless is_atom(name), do: raise(ArgumentError, "expected name atom")

    NewRelic.Tracer.Macro.traced_function_body(body, mod, func, args, name)
  end
end
