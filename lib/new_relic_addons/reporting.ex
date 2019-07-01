defmodule NewRelicAddons.Reporting do
  @moduledoc false

  # Based on `NewRelic.Tracer.Macro.traced_function_body/5`
  # - callable in runtime while the original was a compile-time macro
  def report_event(module, function, args, name \\ nil, timeframe) do
    {{start_time, start_time_mono}, {_end_time, end_time_mono}} = timeframe

    {span, previous_span, previous_span_attrs} =
      NewRelic.DistributedTrace.set_current_span(
        label: {module, function, length(args)},
        ref: make_ref()
      )

    NewRelic.Tracer.Report.call(
      {module, function, args},
      name || function,
      inspect(self()),
      {span, previous_span || :root},
      {start_time, start_time_mono, end_time_mono}
    )

    NewRelic.DistributedTrace.reset_span(
      previous_span: previous_span,
      previous_span_attrs: previous_span_attrs
    )
  end

  # Based on `NewRelic.Tracer.Macro.traced_function_body/5`
  # - callable in runtime while the original was a compile-time macro
  # - calls `report_call/5` instead of `NewRelic.Tracer.Report.call/5`
  def report_datastore_event(datastore, resource, operation, query, timeframe) do
    module = datastore
    function = operation
    args = [query]
    name = String.to_atom(resource)

    {{start_time, start_time_mono}, {_end_time, end_time_mono}} = timeframe

    {span, previous_span, previous_span_attrs} =
      NewRelic.DistributedTrace.set_current_span(
        label: {module, function, length(args)},
        ref: make_ref()
      )

    report_call(
      {module, function, args},
      {name, category: :datastore},
      inspect(self()),
      {span, previous_span || :root},
      {start_time, start_time_mono, end_time_mono}
    )

    NewRelic.DistributedTrace.reset_span(
      previous_span: previous_span,
      previous_span_attrs: previous_span_attrs
    )
  end

  # Based on `NewRelic.Tracer.Report.call/5`
  # - formats operation to include datastore + resource + operation name
  defp report_call(
         {module, function, args},
         {name, category: :datastore},
         pid,
         {id, parent_id},
         {start_time, start_time_mono, end_time_mono}
       ) do
    duration_ms = NewRelic.Tracer.Report.duration_ms(start_time_mono, end_time_mono)
    duration_s = duration_ms / 1000
    arity = length(args)

    # equivalent of original private call to function_name({module, function}, name)
    function_name = "#{inspect(module)}.#{function}:#{name}"

    # equivalent of original private call to function_name({module, function, arity}, name)
    function_name_with_arity = "#{inspect(module)}.#{function}:#{name}/#{arity}"

    NewRelic.Transaction.Reporter.add_trace_segment(%{
      module: module,
      function: function,
      arity: arity,
      name: name,
      args: args,
      pid: pid,
      id: id,
      parent_id: parent_id,
      start_time: start_time,
      start_time_mono: start_time_mono,
      end_time_mono: end_time_mono
    })

    attributes =
      NewRelic.DistributedTrace.get_span_attrs()
      |> Map.put(:args, inspect(args))
      |> Map.put(:statement, List.first(args))

    NewRelic.report_span(
      timestamp_ms: start_time,
      duration_s: duration_s,
      name: function_name_with_arity,
      edge: [span: id, parent: parent_id],
      category: "datastore",
      attributes: attributes
    )

    NewRelic.incr_attributes(
      datastore_call_count: 1,
      datastore_duration_ms: duration_ms,
      "datastore.#{function_name}.call_count": 1,
      "datastore.#{function_name}.duration_ms": duration_ms
    )

    NewRelic.report_aggregate(
      %{
        name: :FunctionTrace,
        mfa: function_name_with_arity,
        metric_category: :datastore
      },
      %{duration_ms: duration_ms, call_count: 1}
    )

    NewRelic.report_metric(
      # changed from :datastore, "Database", inspect(module), function_name(function, name)},
      {:datastore, inspect(module), to_string(name), to_string(function)},
      duration_s: duration_s
    )
  end
end
