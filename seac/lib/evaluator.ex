defmodule SeaC.Evaluator do
  alias SeaC.Environment
  alias SeaC.ReservedWords

  def meaning(expression, env) do
    expression_to_action(expression).(expression, env)
  end

  def expression_to_action(expression) do
    cond do
      is_atom(expression) -> atom_to_action(expression)
      is_list(expression) -> list_to_action(expression)
      true -> fn _, _ -> :unknown end
    end
  end

  def atom_to_action(expression) do
    cond do
      expression == true -> fn _, _ -> true end
      expression == false -> fn _, _-> false end
      is_number?(expression) -> fn _, _-> to_number(expression) |> Tuple.to_list() |> Enum.at(1) end
      is_reserved?(expression) -> fn _, _ -> [:primitive, expression] end
      true -> fn expression, env -> identifier(expression, env) end
    end
  end

  def identifier(expression, env) do
    Environment.environment_lookup(
      env,
      expression,
      fn -> "Unable to resolve " <> Atom.to_string(expression) end
    )
  end

  def is_reserved?(expression), do: ReservedWords.contains(expression)

  def text_of(expression, _ \\ []) do
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
      Enum.empty?(expression) -> fn _, _ -> :apply end
      is_quote?(expression) -> fn _, _ -> text_of(expression) end
      is_lambda?(expression) -> fn _, env -> [:"non-primitive", [env, expression]] end
      is_cond?(expression) -> fn _, _ -> :cond end
      true -> fn _, _ -> :apply end
    end
  end

  def to_number(atom, _ \\ []) do
    try do
      {:ok, String.to_float(Atom.to_string(atom))}
    rescue
      _ ->
        try do
          {:ok, String.to_integer(Atom.to_string(atom))}
        rescue
          ex -> {:err, ex}
        end
    end
  end

  def is_number?(expression) do
    case to_number(expression) do
      {:ok, _} -> true
      _ -> false
    end
  end
end
