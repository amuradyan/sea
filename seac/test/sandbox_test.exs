defmodule SeaC.SandboxTests do
  use ExUnit.Case

  describe "Sandbox" do
    @tag :sandbox
    test "doing stuff" do
      file = "test/fixtures/sandbox.sea"

      assert SeaC.Runner.run_file(file) ==
               [
                 [],
                 [],
                 :none,
                 [[1, 1]],
                 :none,
                 [[1, 1], [2, 3]],
                 [[1, 2], [2, 4], [3, 1], [4, 3]]
               ]
    end
  end
end
