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
    evaluate_true = fn _, _ -> true end
    evaluate_false = fn _, _ -> false end
    evaluate_a_reserved_word = fn _, _ -> [:primitive, expression] end

    evaluate_number = fn _, _ ->
      to_number(expression) |> Tuple.to_list() |> Enum.at(1)
    end

    evaluate_identifier = fn expression, env ->
      identifier(expression, env)
    end

    cond do
      expression == true -> evaluate_true
      expression == false -> evaluate_false
      is_number?(expression) -> evaluate_number
      is_reserved?(expression) -> evaluate_a_reserved_word
      true -> evaluate_identifier
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
    evaluate_quote = fn _, _ -> text_of(expression) end
    evaluate_cond = fn _, _ -> :cond end
    evaluate_application = fn _, _ -> :apply end

    evaluate_lambda = fn _, env ->
      [:"non-primitive", [env, expression]]
    end

    cond do
      Enum.empty?(expression) -> evaluate_application
      is_quote?(expression) -> evaluate_quote
      is_lambda?(expression) -> evaluate_lambda
      is_cond?(expression) -> evaluate_cond
      true -> evaluate_application
    end
  end

  def evaluate_condition() do
    :"???"
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
