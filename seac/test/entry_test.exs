defmodule SeaC.EntryTests do
  use ExUnit.Case

  alias SeaC.Entry
  alias SeaC.EntryRecord

  test "that we are able to create new /empty/ entries" do
    entry = Entry.new_entry
    empty_record = %EntryRecord{names: [], values: []}

    assert Agent.get(entry, fn e -> e end) == empty_record
  end

  test "that we are able to find the value of a known name" do
    entry = Entry.new_entry
    busy_record = %EntryRecord{names: [:x, :alo?], values: [7, "ova"]}

    Agent.update(entry, fn _ -> busy_record end)

    assert Entry.lookup(entry, :alo?) == "ova"
  end

  test "that we gracefully handle the search in an empty entry" do
    entry = Entry.new_entry

    assert Entry.lookup(entry, :x) == "Unable to resolve x"
  end

  test "that we gracefully handle unknown names" do
    entry = Entry.new_entry
    busy_record = %EntryRecord{names: [:x], values: [7]}

    Agent.update(entry, fn _ -> busy_record end)

    assert Entry.lookup(entry, :y) == "Unable to resolve y"
  end
end
