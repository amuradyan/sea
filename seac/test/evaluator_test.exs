defmodule SeaC.EvaluatorTests do
  use ExUnit.Case

  alias SeaC.Evaluator
  alias SeaC.ReservedWords

  test "that we regard the numbers as constants" do
    assert Evaluator.expression_to_action(:"7") == 7
  end

  test "that we regard the Booleans as constants" do
    assert Evaluator.expression_to_action(:true) == true
    assert Evaluator.expression_to_action(:false) == false
  end

  test "that we regard some words as constants" do
    actions_for_reserved_words =
      Enum.map(ReservedWords.all(), fn word -> Evaluator.expression_to_action(word) end)

    expected_outcome =
      Enum.map(ReservedWords.values, fn word -> word end) ++
      Enum.map(ReservedWords.primitives, fn word -> [:primitive, word] end)

    assert actions_for_reserved_words -- expected_outcome |> Enum.empty?()
  end

  test "that we regard some expressions as identifiers" do
    assert Evaluator.expression_to_action(:expression) == :identifier
  end

  test "that we regard some expressions as atoms" do
    assert Evaluator.expression_to_action([:quote, :this]) == :this
    assert Evaluator.expression_to_action([:quote, [:this, :as, :well]]) == [:this, :as, :well]
  end

  test "that we regard some expressions as branchings" do
    assert Evaluator.expression_to_action([:cond, [[:case_clause], [:true_clause]]]) == :cond
  end

  test "that we regard some expressions as anonymous functions" do
    assert Evaluator.expression_to_action([:lambda, [:arguments], [:body]]) == :lambda
  end

  test "that we regard some expressions as function applications" do
    assert Evaluator.expression_to_action([]) == :apply
    assert Evaluator.expression_to_action([[:this], :is, :it]) == :apply
    assert Evaluator.expression_to_action([:this, :is, :it]) == :apply
  end

  test "that we gracefully handle unknown types of expressions" do
    assert Evaluator.expression_to_action("des tination") == :unknown
  end

  test "that we are able to check whether an atom is a number" do
    assert Evaluator.is_number?(:"3") == true
    assert Evaluator.is_number?(:"3a") == false
  end
end
