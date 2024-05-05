defmodule SeaC.Evaluator do
  require Logger
  alias SeaC.Environment
  alias SeaC.ReservedWords

  def meaning(expression, env) do
    Logger.debug("""
      \nExpression: #{Kernel.inspect(expression)}
      \nEnvironment: #{Kernel.inspect(env)}
    """)

    mnng = expression_to_action(expression).(expression, env)

    Logger.debug("""
      \nMeaning of #{Kernel.inspect(expression)}
    is ... #{Kernel.inspect(mnng)}
    """)

    mnng
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
      number?(expression) -> evaluate_number
      reserved?(expression) -> evaluate_a_reserved_word
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

  def reserved?(expression), do: ReservedWords.contains(expression)

  def text_of(expression, _ \\ []) do
    hd(tl(expression))
  end

  def quote?(expression) do
    hd(expression) == :quote
  end

  def lambda?(expression) do
    hd(expression) == :lambda
  end

  def cond?(expression) do
    hd(expression) == :cond
  end

  def list_to_action(expression) do
    evaluate_quote = fn _, _ -> text_of(expression) end
    evaluate_cond = fn _, env -> evaluate_clauses(tl(expression), env) end
    evaluate_application = fn _, env -> application(expression, env) end

    evaluate_lambda = fn _, env ->
      [:"non-primitive", [env, hd(tl(expression)), hd(tl(tl(expression)))]]
    end

    cond do
      Enum.empty?(expression) -> evaluate_application
      quote?(expression) -> evaluate_quote
      lambda?(expression) -> evaluate_lambda
      cond?(expression) -> evaluate_cond
      true -> evaluate_application
    end
  end

  def else_clause?(clause) do
    case clause do
      [] -> false
      [condition | _] -> condition == :else
    end
  end

  def evaluate_list(list, env) do
    case list do
      [] -> []
      [first | rest] -> [meaning(first, env) | evaluate_list(rest, env)]
    end
  end

  def primitive?(function) do
    case function do
      [:primitive | _] -> true
      _ -> false
    end
  end

  def non_primitive?(function) do
    case function do
      [:"non-primitive" | _] -> true
      _ -> false
    end
  end

  def atom?(expression),
    do: primitive?(expression) || non_primitive?(expression) || is_atom(expression)

  def apply_primitive(name, values) do
    first = fn l -> hd(l) end
    second = fn l -> hd(tl(l)) end

    case name do
      :cons -> [first.(values), second.(values)]
      :car -> hd(first.(values))
      :cdr -> tl(first.(values))
      :null? -> first.(values) == []
      :same? -> first.(values) == second.(values)
      :atom? -> is_atom(first.(values))
      :zero? -> first.(values) == 0
      :number? -> is_number(first.(values))
      :+ -> first.(values) + second.(values)
      :- -> first.(values) - second.(values)
    end
  end

  def apply_closure(closure, values) do
    case closure do
      [table, formals, body] ->
        env =
          Environment.extend_environment(table, [formals, values])

        Logger.debug("""
          \nApplying closure #{Kernel.inspect(body)}
          \nIn environment #{Kernel.inspect(env)}
        """)

        meaning(body, env)

      _ ->
        # FIXME
        "invalid closure"
    end
  end

  def apply_function(function, values) do
    cond do
      primitive?(function) -> apply_primitive(hd(tl(function)), values)
      non_primitive?(function) -> apply_closure(hd(tl(function)), values)
      true -> false
    end
  end

  def application(expression, env) do
    apply_function(
      meaning(hd(expression), env),
      evaluate_list(tl(expression), env)
    )
  end

  def value(expression) do
    meaning(expression, [])
  end

  def evaluate_clauses(clauses, env) do
    condition_of = fn clause -> hd(clause) end
    body_of = fn clause -> hd(tl(clause)) end

    case clauses do
      [] ->
        nil

      [first_clause | rest] ->
        cond do
          else_clause?(first_clause) -> meaning(body_of.(first_clause), env)
          meaning(condition_of.(first_clause), env) -> meaning(body_of.(first_clause), env)
          true -> evaluate_clauses(rest, env)
        end
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

  def number?(expression) do
    case to_number(expression) do
      {:ok, _} -> true
      _ -> false
    end
  end
end
