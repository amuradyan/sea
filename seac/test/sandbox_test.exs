defmodule SeaC.SandboxTests do
  use ExUnit.Case

  describe "Sandbox" do
    @tag :sandbox
    test "doing stuff" do
      file = "test/fixtures/sandbox.sea"

      assert SeaC.Runner.run_file(file) == [
               [[1, 2], [2, 3], [3, 4]],
               [[4, 1], [3, 2], [2, 3], [1, 4]],
               [[1, 3], [2, 3], [3, 3], [4, 3]],
               [[2, 1], [2, 2], [2, 3], [2, 4]]
             ]
    end
  end
end
