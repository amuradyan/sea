defmodule SeaC.PreludeTests do
  use ExUnit.Case

  @tag :prelude
  describe "Prelude" do
    test "list" do
      file = "test/fixtures/prelude/list.sea"

      assert SeaC.Runner.run(file) == [1, 2, :պնդուկ, [1, 2]]
    end

    test "identity" do
      file = "test/fixtures/prelude/identity.sea"

      assert SeaC.Runner.run(file) == [
               [],
               :ճպուռ,
               [:մատակ],
               [:մրջյուն, :թրթուռ]
             ]
    end
  end
end
