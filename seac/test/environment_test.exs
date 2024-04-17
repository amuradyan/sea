defmodule SeaC.EnvironmentTest do
  use ExUnit.Case

  alias SeaC.Environment
  alias SeaC.EnvironmentRecord
  alias SeaC.EntryRecord
  alias SeaC.Entry

  test "that we are able to create new /empty/ environments" do
    env = SeaC.Environment.new_environment()
    empty_env = %EnvironmentRecord{entries: []}

    assert Agent.get(env, fn e -> e end) == empty_env
  end

  test "that we are able to extend the environment" do
    entry = Entry.new_entry()
    busy_entry_record = %EntryRecord{names: [:x], values: [7]}
    Agent.update(entry, fn _ -> busy_entry_record end)

    env = Environment.new_environment()
    busy_env_record = %EnvironmentRecord{entries: [entry]}
    Agent.update(env, fn _ -> busy_env_record end)

    test_env = Environment.new_environment()
    Environment.extend_environment(test_env, entry)

    assert Environment.peek(test_env) == [[[:x], [7]]]
  end

  test "that we are able to peek into an env at any given moment" do
    first_entry = Entry.new_entry()
    busy_entry_record = %EntryRecord{names: [:x], values: [7]}
    Agent.update(first_entry, fn _ -> busy_entry_record end)
    second_entry = Entry.new_entry()
    another_busy_entry_record = %EntryRecord{names: [:y], values: [8]}
    Agent.update(second_entry, fn _ -> another_busy_entry_record end)

    env = Environment.new_environment()
    busy_env_record = %EnvironmentRecord{entries: [first_entry | [second_entry]]}
    Agent.update(env, fn _ -> busy_env_record end)

    assert Environment.peek(env) == [[[:y], [8]], [[:x], [7]]]
  end

  test "that we are able to lookup the value of a known name" do
    first_entry = Entry.new_entry()
    busy_entry_record = %EntryRecord{names: [:x], values: [7]}
    Agent.update(first_entry, fn _ -> busy_entry_record end)
    second_entry = Entry.new_entry()
    another_busy_entry_record = %EntryRecord{names: [:y], values: [9]}
    Agent.update(second_entry, fn _ -> another_busy_entry_record end)

    env = Environment.new_environment()
    busy_env_record = %EnvironmentRecord{entries: [first_entry | [second_entry]]}
    Agent.update(env, fn _ -> busy_env_record end)

    name = :y
    value = Environment.lookup(env, name, fn -> "Unable to resolve " <> Atom.to_string(name) end)

    assert value == 9
  end

  test "that we gracefully handle the lookup in an empty table" do
    value =
      Environment.lookup(
        Environment.new_environment(),
        :x,
        fn ->
          "Unable to resolve " <> Atom.to_string(:x)
        end
      )

    assert value == "Unable to resolve x"
  end

  test "that we gracefully handle unknown names" do
    entry = Entry.new_entry
    busy_entry_record = %EntryRecord{names: [:x], values: [7]}
    Agent.update(entry, fn _ -> busy_entry_record end)

    env = Environment.new_environment
    busy_env_record = %EnvironmentRecord{entries: [entry]}
    Agent.update(env, fn _ -> busy_env_record end)

    name = :y
    value = Environment.lookup(env, :y, fn -> "Unable to resolve " <> Atom.to_string(name) end)

    assert value == "Unable to resolve y"
  end
end
