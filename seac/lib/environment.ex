defmodule SeaC.Environment do
  alias SeaC.Environment

  @type env :: %Environment{name: atom(), frames: [nonempty_maybe_improper_list()]}
  defstruct [name: :global , frames: []]

  @spec new(atom()) :: Environment.env()
  def new(name) do
    %Environment{name: name, frames: []}
  end

  @spec environment_lookup(Environment.env(), any(), any()) :: any()
  def environment_lookup(env, name, fallback) do
    case env.frames do
      [] ->
        fallback.()

      [entry | rest] ->
        entry_lookup(
          entry,
          name,
          fn -> environment_lookup(%{env | frames: rest}, name, fallback) end
        )
    end
  end

  @spec entry_lookup(list(), any(), fun()) :: any()
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

  @spec extend_environment(Environment.env(), [list()]) :: Environment.env()
  def extend_environment(env, entry), do: %{env | frames: [entry | env.frames]}

  @spec extend_entry(list(), atom(), any()) :: list()
  def extend_entry(entry, formal, value) do
    formals_of = fn entry -> hd(entry) end
    values_of = fn entry -> hd(tl(entry)) end

    [formals_of.(entry) ++ [formal], values_of.(entry) ++ [value]]
  end
end
