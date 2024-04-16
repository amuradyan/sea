defmodule SeaC.EntryTests do
  use ExUnit.Case

  alias SeaC.Entry
  alias SeaC.Record

  test "that we are able to create new /empty/ entries" do
    {s, entry} = Entry.new_entry

    assert s == :ok
    assert Agent.get(entry, fn e -> e end) == %Record{names: [], values: []}
  end

  test "that we are able to find the value of a known name" do
    {_, entry} = Entry.new_entry
    Agent.update(entry, fn entry -> %Record{names: [:x, :alo?], values: [7, "ova"]} end)

    assert Entry.lookup(entry, :alo?) == "ova"
  end

  test "that we gracefully handle the search in an empty entry" do
    {_, entry} = Entry.new_entry

    assert Entry.lookup(entry, :x) == "Unable to resolve x"
  end

  test "that we gracefully handle unknown names" do
    {_, entry} = Entry.new_entry
    Agent.update(entry, fn entry -> %Record{names: [:x], values: [7]} end)

    assert Entry.lookup(entry, :y) == "Unable to resolve y"
  end
end
