defmodule SeaC.Evaluator do
  def expression_to_action(expression) do
    cond do
      is_atom(expression) -> :atom
      is_list(expression) -> :list
      true -> :unknown
    end
  end
end
