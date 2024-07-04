defmodule SeaC.PreludeTests do
  use ExUnit.Case

  test "list" do
    file = "test/fixtures/prelude/list.sea"

    assert SeaC.Runner.run(file) == [1, :"2", :պնդուկ, [1, 2]]
  end
end
