defmodule SeaC.Evaluator do
  alias SeaC.ReservedWords

  def expression_to_action(expression) do
    cond do
      is_atom(expression) -> atom_to_action(expression)
      is_list(expression) -> list_to_action(expression)
      true -> :unknown
    end
  end

  def atom_to_action(expression) do
    cond do
      expression == true -> :const
      expression == false -> :const
      is_number?(expression) -> :const
      ReservedWords.contains(expression) -> :const
      true -> :identifier
    end
  end

  def text_of(expression) do
    hd(tl(expression))
  end

  def is_quote?(expression) do
     hd(expression) == :quote
  end

  def is_lambda?(expression) do
    hd(expression) == :lambda
  end

  def is_cond?(expression) do
    hd(expression) == :cond
  end

  def list_to_action(expression) do
    cond do
      Enum.empty?(expression) -> :apply
      is_quote?(expression) -> text_of(expression)
      is_lambda?(expression) -> :lambda
      is_cond?(expression) -> :cond
      true -> :apply
    end
  end

  def is_number?(atom) do
    try do
      is_number(String.to_integer(Atom.to_string(atom)))
    rescue
      _ -> false
    end
  end
end
