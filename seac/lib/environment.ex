defmodule SeaC.Environment do
  use Agent

  alias SeaC.Entry
  alias SeaC.EnvironmentRecord

  def new_environment do
    clean_env_record =
      %EnvironmentRecord{entries: []}

    {_, env} =
      Agent.start_link(fn -> clean_env_record end)

    env
  end

  def lookup_helper(record, name, fallback) do
    case record.entries do
      [] ->
        fallback.()

      [first | rest] ->
        Entry.lookup(
          first,
          name,
          fn -> lookup_helper(%EnvironmentRecord{entries: rest}, name, fallback) end
        )
    end
  end

  def lookup(env, name, fallback) do
    Agent.get(
      env,
      fn record -> lookup_helper(record, name, fallback) end
    )
  end

  def extend_environment(env, entry) do
    Agent.update(env, fn record ->
      %EnvironmentRecord{entries: [entry | record.entries]}
    end)
  end

  def peek(env) do
    er = Agent.get(env, fn r -> r end)

    List.foldl(er.entries, [], fn e, acc ->
      [Agent.get(e, fn en -> [en.names, en.values] end) | acc]
    end)
  end
end
