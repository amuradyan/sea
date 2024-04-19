defmodule SeaC.ReservedWords do
  @primitives [
    :cons,
    :car,
    :cdr,
    :null?,
    :same?,
    :atom?,
    :zero?,
    :number?,
    :-,
    :+
  ]

  @values [true, false]

  def all, do: @primitives ++ @values

  def primitives, do: @primitives

  def values, do: @values

  def contains(word), do: not (Enum.find(all(), fn e -> e == word end) |> is_nil)
end
