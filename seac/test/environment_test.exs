defmodule SeaC.EnvironmentTest do
  use ExUnit.Case

  alias SeaC.Environment

  @tag :environment
  test "that the default environment is created under the name of :global and with no frames" do
    assert %Environment{} == %Environment{name: :global, frames: []}
  end

  @tag :environment
  test "that we are able to create an environment with a custom name" do
    env = Environment.new(:local)

    assert env == %Environment{name: :local, frames: []}
  end

  @tag :environment
  test "that we are able to extend the environment" do
    env = %Environment{frames: [[[:r], [9]]]}
    entry = [[:l], [10]]

    extended_environment = Environment.extend_environment(env, entry)

    assert extended_environment == %Environment{frames: [[[:l], [10]], [[:r], [9]]]}
  end

  @tag :environment
  test "that we are able to extend the entry" do
    entry = [[:v, :l], [0, 10]]

    extended_entry = Environment.extend_entry(entry, :m, 20)

    assert extended_entry == [[:v, :l, :m], [0, 10, 20]]
  end

  @tag :environment
  test "that we are able to lookup the value of a known name" do
    env = %Environment{frames: [[[:x], [7]], [[:y], [9]]]}
    name = :y

    value =
      Environment.environment_lookup(
        env,
        name,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == 9
  end

  @tag :environment
  test "that we gracefully handle the lookup in an empty table" do
    name = :x

    value =
      Environment.environment_lookup(
        %Environment{},
        name,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == "Unable to resolve x"
  end

  @tag :environment
  test "that we gracefully handle unknown names in environments" do
    env = %Environment{frames: [[[:x], [7]]]}
    name = :y

    value =
      Environment.environment_lookup(
        env,
        :y,
        fn -> "Unable to resolve " <> Atom.to_string(name) end
      )

    assert value == "Unable to resolve y"
  end

  @tag :environment
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

  @tag :environment
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

  @tag :environment
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
