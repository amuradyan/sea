defmodule SeaC.Evaluator do
  require Logger

  alias SeaC.Environment
  alias SeaC.ReservedWords

  def meaning(expression, env) do
    # Logger.debug("""
    #   \nExpression: #{Kernel.inspect(expression)}
    #   \nEnvironment: #{Kernel.inspect(env)}
    # """)

    mnng =
      case expression do
        [[:define, name, value] | rest] ->
          extended_env = define([:define, name, value], env)

          case rest do
            [expression] -> meaning(expression, extended_env)
            _ -> meaning(rest, extended_env)
          end

        _ ->
          expression_to_action(expression).(expression, env)
      end

    # Logger.debug("""
    #   \nMeaning of #{Kernel.inspect(expression)}
    # is ... #{Kernel.inspect(mnng)}
    # """)

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
    token = hd(tl(expression))

    case to_number(token) do
      {:ok, number} -> number
      _ -> token
    end
  end

  def quote?(expression) do
    hd(expression) == :quote
  end

  def stub?(expression) do
    hd(expression) == :"???"
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

    params_of = fn l -> hd(tl(l)) end
    body_of = fn l -> hd(tl(tl(l))) end

    evaluate_lambda = fn lambda, env ->
      [:"non-primitive", [env, params_of.(lambda), body_of.(lambda)]]
    end

    cond do
      Enum.empty?(expression) -> evaluate_application
      quote?(expression) -> evaluate_quote
      lambda?(expression) -> evaluate_lambda
      stub?(expression) -> raise("To be implemented...")
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
      :cons ->
        case {first.(values), second.(values)} do
          {_, []} ->
            [first.(values)]

          {_, tail} ->
            if is_list(tail) do
              [first.(values) | second.(values)]
            else
              [first.(values), second.(values)]
            end
        end

      :car ->
        hd(first.(values))

      :cdr ->
        tl(first.(values))

      :null? ->
        first.(values) == []

      :atom? ->
        is_atom(first.(values))

      :zero? ->
        first.(values) == 0

      :number? ->
        is_number(first.(values))

      :+ ->
        List.foldl(values, 0, fn e, acc -> acc + e end)

      :- ->
        List.foldl(tl(values), first.(values), fn e, acc -> acc - e end)

      :/ ->
        List.foldl(tl(values), first.(values), fn e, acc -> acc / e end)

      :* ->
        List.foldl(values, 1, fn e, acc -> acc * e end)

      :or ->
        List.foldl(values, false, fn e, acc -> acc || e end)

      :and ->
        List.foldl(values, true, fn e, acc -> acc && e end)

      :not ->
        not first.(values)

      :same? ->
        first.(values) == second.(values)

      :lt? ->
        first.(values) < second.(values)

      :lte? ->
        first.(values) <= second.(values)

      :gt? ->
        first.(values) > second.(values)

      :gte? ->
        first.(values) >= second.(values)

      :ne? ->
        first.(values) != second.(values)
    end
  end

  def create_closure_env_entry(formals, values) do
    create_closure_env_entry(formals, values, [[], []])
  end

  def create_closure_env_entry(formals, values, entry) do
    # TODO: solve for same name formals
    # TODO: solve for more than one variadic params
    # TODO: solve for variadic params not at the end of the formal list
    case {formals, values} do
      {[first_formal | other_formals], [first_value | other_values]} ->
        cond do
          String.starts_with?(Atom.to_string(first_formal), ".") ->
            Environment.extend_entry(entry, first_formal, values)

          true ->
            extended_entry =
              Environment.extend_entry(entry, first_formal, first_value)

            create_closure_env_entry(other_formals, other_values, extended_entry)
        end

      {[], _} ->
        entry
    end
  end

  def apply_closure(closure, values, outer_env) do
    case closure do
      [table, formals, body] ->
        entry =
          create_closure_env_entry(formals, values)

        # FIXME: this is ugly
        xenv = Environment.extend_environment(table, entry)
        oframes = outer_env.frames
        env = %Environment{frames: xenv.frames ++ oframes}

        # Logger.debug("""
        #   \nApplying closure #{Kernel.inspect(body)}
        #   \nIn environment #{Kernel.inspect(env)}
        # """)

        meaning(body, env)

      _ ->
        # FIXME
        "invalid closure"
    end
  end

  def apply_function(function, values, env) do
    cond do
      primitive?(function) -> apply_primitive(hd(tl(function)), values)
      non_primitive?(function) -> apply_closure(hd(tl(function)), values, env)
      true -> [:unknown_function, function]
    end
  end

  def application(expression, env) do
    apply_function(
      meaning(hd(expression), env),
      evaluate_list(tl(expression), env),
      env
    )
  end

  def value(expression) do
    meaning(expression, %Environment{})
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

  def define([:define, name, value], env) do
    Environment.extend_environment(env, [[name], [meaning(value, env)]])
  end
end
