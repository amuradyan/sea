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

  def list_to_action(expression) do
    :"???"
  end

  def is_number?(atom) do
    try do
      is_number(String.to_integer(Atom.to_string(atom)))
    rescue
      _ -> false
    end
  end
end
