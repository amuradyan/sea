defmodule SeaC.SandboxTests do
  use ExUnit.Case

<<<<<<< HEAD
  describe "Sandbox" do
    @tag :sandbox
=======
  @tag :sandbox
  describe "Sandbox" do
>>>>>>> a0e0381 (chore: tracking sandbox because it got interesting)
    test "doing stuff" do
      file = "test/fixtures/sandbox.sea"

      assert SeaC.Runner.run(file) == [
               [[1, 2], [2, 3], [3, 4]],
               [[4, 1], [3, 2], [2, 3], [1, 4]],
               [[1, 3], [2, 3], [3, 3], [4, 3]],
               [[2, 1], [2, 2], [2, 3], [2, 4]]
             ]
    end
  end
end
