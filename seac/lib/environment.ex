defmodule SeaC.Environment do
  def environment_lookup(env, name, fallback) do
    case env do
      [] ->
        fallback.()

      [first | rest] ->
        entry_lookup(
          first,
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
end
