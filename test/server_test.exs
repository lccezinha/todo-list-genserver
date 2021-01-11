defmodule Todoer.ServerTest do
  use ExUnit.Case

  alias Todoer.Server

  setup do
    {:ok, pid} = Server.start_link()
    %{pid: pid}
  end

  test "todoer_server starts empty", %{pid: pid} do
    assert Server.entries(pid) == []
  end

  test "adding new entry", %{pid: pid} do
    entry = %{name: "Test", date: {2020, 01, 01}}

    Server.add_entry(pid, entry)

    assert length(Server.entries(pid)) == 1
    assert Server.entries(pid) == [Map.put(entry, :id, 1)]
  end

  test "updating entry", %{pid: pid} do
    entry = %{name: "Test", date: {2020, 01, 01}}

    Server.add_entry(pid, entry)

    Server.update_entry(pid, 1, &Map.replace(&1, :name, "New Name"))

    assert Server.entries(pid) == [%{name: "New Name", date: {2020, 01, 01}, id: 1}]
  end

  test "delete entry", %{pid: pid} do
    entry = %{name: "Test", date: {2020, 01, 01}}
    entry_two = %{name: "Test #2", date: {2020, 01, 01}}

    Server.add_entry(pid, entry)
    Server.add_entry(pid, entry_two)

    assert length(Server.entries(pid)) == 2

    Server.delete_entry(pid, 1)

    assert length(Server.entries(pid)) == 1
    assert Server.entries(pid) ==  [%{name: "Test #2", date: {2020, 01, 01}, id: 2}]
  end

end
