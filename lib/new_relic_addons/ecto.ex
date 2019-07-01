defmodule NewRelicAddons.Ecto do
  @moduledoc """
  Provides Ecto instrumentation based on telemetry.

  ## Features

  - reports database operations with repo, table and operation name
  - reports database operations with SQL statements visible within transaction traces
  - reports queue & decode events visible next to relevant query events in transaction traces

  ## Usage

  You just need to attach telemetry event handler in `application.ex`:

      :telemetry.attach(
        "my-app-ecto",
        [:my_app, :repo, :query],
        &NewRelicAddons.Ecto.handle_event/4,
        []
      )

  Remember to replace the `:my_app` with your OTP app name and `:repo` with underscored repo name.
  """

  @doc false
  def handle_event(event, times, metadata, _config) do
    with [_, _, :query] <- event,
         %{type: :ecto_sql_query} <- metadata,
         %{repo: repo, source: source, query: query, result: {:ok, result}} <- metadata,
         %{queue_time: queue_time, query_time: query_time, decode_time: decode_time} <- times do
      table = source || get_table_from_query(query) || "unknown"
      operation = get_operation_from_result(result)
      times = {queue_time, query_time, decode_time}

      put_stage_spans(repo, table, operation, query, times)
    else
      _ -> :ignore
    end
  end

  defp get_table_from_query(query) do
    Regex.named_captures(~r/(INSERT INTO|UPDATE) "(?<table>\w+)"/, query)["table"]
  end

  defp get_operation_from_result(result)
  defp get_operation_from_result(%{__struct__: Postgrex.Result, command: op}), do: op
  defp get_operation_from_result(_), do: nil

  defp put_stage_spans(repo, table, operation, query, times) do
    alias NewRelicAddons.Reporting

    {queue_timeframe, query_timeframe, decode_timeframe} = calculate_stage_timeframes(times)

    Reporting.report_event(repo, :queue, [], queue_timeframe)
    Reporting.report_datastore_event(repo, table, operation, query, query_timeframe)
    Reporting.report_event(repo, :decode, [], decode_timeframe)
  end

  defp calculate_stage_timeframes({queue_time, query_time, decode_time}) do
    now = time_tuple_now()

    decode_end = now
    decode_start = time_tuple_add(decode_end, -(decode_time || 0))
    decode_timeframe = {decode_start, decode_end}

    query_end = decode_start
    query_start = time_tuple_add(query_end, -(query_time || 0))
    query_timeframe = {query_start, query_end}

    queue_end = query_start
    queue_start = time_tuple_add(queue_end, -(queue_time || 0))
    queue_timeframe = {queue_start, queue_end}

    {queue_timeframe, query_timeframe, decode_timeframe}
  end

  defp time_tuple_now do
    {System.system_time(), System.monotonic_time()}
  end

  defp time_tuple_add({system, monotonic}, diff) do
    {system + diff, monotonic + diff}
  end
end
