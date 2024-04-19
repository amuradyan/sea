defmodule SeaC.ReservedWords do
  @reserved_words [
    true,
    false,
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

  def all, do: @reserved_words

  def contains(word), do: not (Enum.find(@reserved_words, fn e -> e == word end) |> is_nil)
end
