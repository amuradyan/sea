defmodule SeaC.PreludeTests do
  use ExUnit.Case

  describe "Prelude" do
    test "list" do
      file = "test/fixtures/prelude/list.sea"

      assert SeaC.Runner.run(file) == [1, 2, :պնդուկ, [1, 2]]
    end
  end
end
