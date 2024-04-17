defmodule SeaC.Entry do
  alias SeaC.EntryRecord

  def new_entry do
    {_, entry} = Agent.start_link(fn -> %EntryRecord{names: [], values: []} end)
    entry
  end

  def lookup_helper(record, name, fallback) do
    case record.names do
      [] ->
        fallback.()

      [first_name | _] when first_name == name ->
        hd(record.values)

      [_ | names] ->
        lookup_helper(%EntryRecord{names: names, values: tl(record.values)}, name, fallback)
    end
  end

  def lookup(entry, name, fallback) do
    Agent.get(
      entry,
      fn record -> lookup_helper(record, name, fallback) end
    )
  end
end
