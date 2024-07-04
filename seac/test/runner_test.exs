defmodule SeaC.RunnerTests do
  use ExUnit.Case

  test "that we can run a Sea file" do
    file = "test/fixtures/length-y.sea"

    assert SeaC.Runner.run(file) == 3
  end

  test "that we can understand a definition in a function" do
    file = "test/fixtures/definitions/define-in-a-function.sea"

    assert SeaC.Runner.run(file) == 6
  end

  test "that we can handle variadic parameters" do
    file = "test/fixtures/varargs.sea"

    assert SeaC.Runner.run(file) == [3, 4, 5]
  end

  test "the N-queen problem" do
    file = "test/fixtures/n-queens.sea"

    assert SeaC.Runner.run(file) ==
             [
               [[1, 3], [2, 1]],
               [[1, 1], [2, 3]]
             ]
  end

end
