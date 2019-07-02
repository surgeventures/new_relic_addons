defmodule NewRelicSandbox.Accounts.OldUserPeriodicDeletion do
  use GenServer
  use NewRelicAddons.Decorators

  @interval_sec 30
  @remove_before_sec 60 * 10

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    Process.send_after(self(), :process, 0)

    {:ok, nil}
  end

  @impl GenServer
  def handle_info(:process, _) do
    interval = System.convert_time_unit(@interval_sec, :second, :millisecond)
    process()
    Process.send_after(self(), :process, interval)

    {:noreply, nil}
  end

  @decorate new_relic_transaction()
  defp process do
    NewRelicSandbox.Accounts.delete_old_users(@remove_before_sec)
  end
end
