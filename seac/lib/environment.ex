defmodule SeaC.Environment do
  alias SeaC.Environment

  @type env :: %Environment{name: atom(), frames: [nonempty_maybe_improper_list()]}
  defstruct [name: :global , frames: []]

  @spec new() :: Environment.env()
  def new do
    %Environment{name: :global, frames: []}
  end

  @spec new(atom()) :: Environment.env()
  def new(name) do
    %Environment{name: name, frames: []}
  end

  def environment_lookup(env, name, fallback) do
    case env do
      [] ->
        fallback.()

      [entry | rest] ->
        entry_lookup(
          entry,
          name,
          fn -> environment_lookup(rest, name, fallback) end
        )
    end
  end

  def entry_lookup(entry, name, fallback) do
    case entry do
      [] ->
        fallback.()

      [[], _] ->
        fallback.()

      [_, []] ->
        fallback.()

      [[first_name | _], [first_value | _]] when first_name == name ->
        first_value

      [[_ | names], [_ | values]] ->
        entry_lookup([names, values], name, fallback)
    end
  end

  def extend_environment(env, entry), do: [entry | env]

  def extend_entry(entry, formal, value) do
    formals_of = fn entry -> hd(entry) end
    values_of = fn entry -> hd(tl(entry)) end

    [formals_of.(entry) ++ [formal], values_of.(entry) ++ [value]]
  end
end
