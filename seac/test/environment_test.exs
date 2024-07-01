defmodule SeaC.EnvironmentTest do
  use ExUnit.Case

  alias SeaC.Environment

  test "that we are able to extend the environment" do
    env = [[[:r], [9]]]
    entry = [[:l], [10]]

    extended_environment = Environment.extend_environment(env, entry)

    assert extended_environment == [[[:l], [10]], [[:r], [9]]]
  end

  test "that we are able to extend the entry" do
    entry = [[:v, :l], [0, 10]]

    extended_entry = Environment.extend_entry(entry, :m, 20)

    assert extended_entry == [[:v, :l, :m], [0, 10, 20]]
  end

  test "that we are able to lookup the value of a known name" do
    env = [[[:x], [7]], [[:y], [9]]]
    name = :y

    value =
      Environment.environment_lookup(
        env,
        name,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == 9
  end

  test "that we gracefully handle the lookup in an empty table" do
    name = :x

    value =
      Environment.environment_lookup(
        [],
        name,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == "Unable to resolve x"
  end

  test "that we gracefully handle unknown names in environments" do
    env = [[[:x], [7]]]
    name = :y

    value =
      Environment.environment_lookup(
        env,
        :y,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == "Unable to resolve y"
  end

  test "that we are able to find the value of a known name" do
    entry = [[:x, :alo?], [7, "ova"]]
    name = :alo?

    value =
      Environment.entry_lookup(
        entry,
        name,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == "ova"
  end

  test "that we gracefully handle the search in an empty entry" do
    name = :x

    value =
      Environment.entry_lookup(
        [],
        name,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == "Unable to resolve x"
  end

  test "that we gracefully handle unknown names in entries" do
    entry = [[:x], [7]]
    name = :y

    value =
      Environment.entry_lookup(
        entry,
        name,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == "Unable to resolve y"
  end
end
