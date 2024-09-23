defmodule SeaC.RunnerTests do
  use ExUnit.Case

  describe "The Sea runner" do
    @tag :runner
    test "that we can run a Sea file" do
      file = "test/fixtures/length-y.sea"

      assert SeaC.Runner.run(file) == 3
    end

    @tag :runner
    test "that we can understand a definition in a function" do
      file = "test/fixtures/definitions/define-in-a-function.sea"

      assert SeaC.Runner.run(file) == 6
    end

    @tag :runner
    test "that we can handle variadic parameters" do
      file = "test/fixtures/varargs.sea"

      assert SeaC.Runner.run(file) == [3, 4, 5]
    end

    # @tag :runner
    # @tag :"n-queens"
    # test "the solution to the N-queen problem" do
    #   file = "test/fixtures/n-queens.sea"

    #   assert SeaC.Runner.run(file) ==
    #            [
    #              [[1, 3], [2, 1]],
    #              [[1, 1], [2, 3]]
    #            ]
    # end
  end
end
