defmodule SeaC.ClosureTests do
  use ExUnit.Case

  alias SeaC.Evaluator
  alias SeaC.Environment

  @tag :closure
  test "that we are able to apply closures" do
    closure_table = %Environment{}
    closure_formals = [:x]
    closure_body = :x

    closure = [closure_table, closure_formals, closure_body]

    assert Evaluator.apply_closure(closure, [5], %Environment{}) == 5
  end

  @tag :closure
  test "that we generate proper env entries for variadic closures" do
    formals = [:x, :".y"]
    values = [1, 2, 3]
    proper_entry = [[:x, :".y"], [1, [2, 3]]]

    entry = Evaluator.create_closure_env_entry(formals, values)

    assert entry == proper_entry
  end

  @tag :closure
  # what abou the empty spread case?
  test "that we are able to apply closures with variadic params" do
    closure_table = %Environment{}
    closure_formals = [:first, :second, :".rest"]
    closure_body = [:cons, [:+, :first, :second], :".rest"]

    closure = [closure_table, closure_formals, closure_body]

    assert Evaluator.apply_closure(closure, [1, 2, 4, 5], %Environment{}) == [3, 4, 5]
  end
end
