defmodule Todoer.Server do
  use GenServer

  alias Todoer

  # Public API

  def start_link() do
    GenServer.start_link(__MODULE__, Todoer.new())
  end

  def entries(pid, date \\ {2020, 01, 01}) do
    GenServer.call(pid, {:entries, date})
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def update_entry(pid, entry_id, updated_entry_function) do
    GenServer.cast(pid, {:update_entry, entry_id, updated_entry_function})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:delete_entry, entry_id})
  end

  # Private API

  @impl GenServer
  def init(entries) do
    {:ok, entries}
  end

  @impl GenServer
  def handle_call({:entries, date}, _pid_from, state) do
    {:reply, Todoer.entries(state, date), state}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, state) do
    {:noreply, Todoer.add_entry(state, entry)}
  end

  @impl GenServer
  def handle_cast({:update_entry, entry_id, updated_entry_function}, state) do
    {:noreply, Todoer.update_entry(state, entry_id, updated_entry_function)}
  end

  @impl GenServer
  def handle_cast({:delete_entry, entry_id}, state) do
    {:noreply, Todoer.delete_entry(state, entry_id)}
  end
end
