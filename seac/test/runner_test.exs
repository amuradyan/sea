defmodule SeaC.RunnerTests do
  use ExUnit.Case

  describe "The Sea runner" do
    @tag :runner
    test "that we can run a Sea file" do
      file = "test/fixtures/length-y.sea"

      assert SeaC.Runner.run_file(file) == 3
    end

    @tag :runner
    test "that we can understand a definition in a function" do
      file = "test/fixtures/definitions/define-in-a-function.sea"

      assert SeaC.Runner.run_file(file) == 6
    end

    @tag :runner
    test "that we can handle variadic parameters" do
      file = "test/fixtures/varargs.sea"

      assert SeaC.Runner.run_file(file) == [3, 4, 5]
    end
  end

  @tag :runner
  test "that we can run a program as a string" do
    program = "((define f (lambda (x y) (+ y x)))(f 1 2))"

    assert SeaC.Runner.run(program) == 3
  end

  @tag :runner
  test "that we can solve the N-queens problem" do
    file = "test/fixtures/n-queens.sea"

    assert SeaC.Runner.run_file(file) == [[[1, 2], [2, 4], [3, 1], [4, 3]]]
  end
end
