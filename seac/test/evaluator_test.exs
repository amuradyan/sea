defmodule SeaC.EvaluatorTests do
  use ExUnit.Case

  alias SeaC.Evaluator
  alias SeaC.ReservedWords

  test "that we regard the numbers as constants" do
    assert Evaluator.meaning(:"7", []) == 7
    assert Evaluator.meaning(:"7.7", []) == 7.7
  end

  test "that we regard the Booleans as constants" do
    assert Evaluator.meaning(:true, []) == true
    assert Evaluator.meaning(:false ,[]) == false
  end

  test "that we regard some words as constants" do
    actions_for_reserved_words =
      Enum.map(ReservedWords.all(), fn word -> Evaluator.meaning(word, []) end)

    expected_outcome =
      Enum.map(ReservedWords.values, fn word -> word end) ++
      Enum.map(ReservedWords.primitives, fn word -> [:primitive, word] end)

    assert actions_for_reserved_words -- expected_outcome |> Enum.empty?()
  end

  test "that we regard some expressions as identifiers" do
    identifier = :birthmarks
    env = [[[:scars, identifier], [4, :none]]]

    resolved_identifier = Evaluator.meaning(identifier, env)
    unresolved_identifier = Evaluator.meaning(:unknown, env)

    assert resolved_identifier == :none
    assert unresolved_identifier == "Unable to resolve unknown"
  end

  test "that we regard some expressions as atoms" do
    assert Evaluator.meaning([:quote, :this], []) == :this
    assert Evaluator.meaning([:quote, [:this, :as, :well]], []) == [:this, :as, :well]
  end

  test "that we regard some expressions as anonymous functions" do
    env = []
    lambda = [:lambda, [:a, :b], [:+, :a, :b]]
    value = [:"non-primitive", [env, lambda]]

    assert Evaluator.meaning(lambda, env) == value
  end

  test "that we regard some expressions as function applications" do
    # assert Evaluator.list_to_action([]) == :apply
    # assert Evaluator.list_to_action([[:this], :is, :it]) == :apply
    # assert Evaluator.list_to_action([:this, :is, :it]) == :apply
    :"???"
  end

  test "that we can interpret Sea functions as atoms" do
    assert Evaluator.atom?(true) == true
    assert Evaluator.atom?(:ping) == true
    assert Evaluator.atom?([]) == false
    assert Evaluator.atom?([:primitive, :function]) == true
    assert Evaluator.atom?([:"non-primitive", :function]) == true
  end

  test "that we should be able to apply primitive functions" do
    assert Evaluator.apply_primitive(:cons, [1, [2]]) == [1, [2]]
    assert Evaluator.apply_primitive(:car, [1]) == 1
    assert Evaluator.apply_primitive(:cdr, [1, 2]) == [2]
    assert Evaluator.apply_primitive(:null?, [[]]) == true
    assert Evaluator.apply_primitive(:null?, [1, 2]) == false
    assert Evaluator.apply_primitive(:same?, [1, true]) == false
    assert Evaluator.apply_primitive(:same?, [[1], [1]]) == true
    assert Evaluator.apply_primitive(:same?, [:b, :b]) == true
    assert Evaluator.apply_primitive(:atom?, [:values]) == true
    assert Evaluator.apply_primitive(:atom?, [[]]) == false
    assert Evaluator.apply_primitive(:atom?, [true]) == true
    assert Evaluator.apply_primitive(:zero?, [0]) == true
    assert Evaluator.apply_primitive(:zero?, [1]) == false
    assert Evaluator.apply_primitive(:zero?, [:f]) == false
    assert Evaluator.apply_primitive(:number?, [7]) == true
    assert Evaluator.apply_primitive(:number?, [6.6]) == true
    assert Evaluator.apply_primitive(:number?, [[7]]) == false
    assert Evaluator.apply_primitive(:number?, [true]) == false
    assert Evaluator.apply_primitive(:+, [1, 2]) == 3
    assert Evaluator.apply_primitive(:-, [1, 2]) == -1
  end

  test "that we can evaluate a list" do
    env = [[[:x], [2]]]

    assert Evaluator.evaluate_list([[:quote, :mek], :x , :"3"], env) == [:mek, 2, 3]
    assert Evaluator.evaluate_list([], env) == []
  end

  test "that we gracefully handle unknown types of expressions" do
    assert Evaluator.meaning("des tination", []) == :unknown
  end

  test "that we are able to check whether an atom is a number" do
    assert Evaluator.number?(:"3") == true
    assert Evaluator.number?(:"3a") == false
  end

  test "that we are able to distinguish `else` clauses in conditions" do
    assert Evaluator.else_clause?([:else, [:body]]) == true
    assert Evaluator.else_clause?([:ololo, [:body]]) == false
    assert Evaluator.else_clause?([]) == false
  end

  test "that we can fall back to `else` clause, while evaluating the condition" do
    env = [[[:always, :one], [false, 1]]]

    false_clause = [:always, :unknown]
    else_clause = [:else, :one]

    assert Evaluator.evaluate_clauses([false_clause, else_clause], env) == 1
  end

  test "that we are able to evaluate condition clauses" do
    env = [[[:always, :sometimes, :two], [false, true, 2]]]

    false_clause = [:always, 1]
    true_clause = [:sometimes, :two]
    else_clause = [:else, 3]

    assert Evaluator.evaluate_clauses([false_clause, true_clause, else_clause], env) == 2
  end
end
