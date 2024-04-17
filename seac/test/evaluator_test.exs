defmodule SeaC.EvaluatorTests do
  use ExUnit.Case

  alias SeaC.Evaluator

  test "that we can choose the appropriate action for atoms" do
    assert Evaluator.expression_to_action(:expression) == :atom
  end

  test "that we can choose the appropriate action for lists" do
    assert Evaluator.expression_to_action([:expression]) == :list
  end

  test "that we gracefully handle unknown structures" do
    assert Evaluator.expression_to_action("[:expression]") == :unknown
  end
end
