defmodule SeaC.Entry do
  alias SeaC.Record

  def new_entry do
    Agent.start_link(fn -> %Record{ names: [], values: [] } end)
  end

  def lookup_helper(record, name, fallback) do
    case record.names do
      [] -> fallback.()
      [first_name | _] when first_name == name -> hd(record.values)
      [_ | names] ->
        lookup_helper(%Record{names: names, values: tl(record.values)}, name, fallback)
    end
  end

  def lookup(entry, name) do
    Agent.get(
      entry,
      fn record -> lookup_helper(record, name, fn -> "Unable to resolve " <> Atom.to_string(name) end) end)
  end
end
