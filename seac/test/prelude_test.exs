defmodule SeaC.PreludeTests do
  use ExUnit.Case

  describe "Prelude" do
    @tag :prelude
    test "map" do
      file = "test/fixtures/prelude/map.sea"

      assert SeaC.Runner.run(file) == [[2, 3, 4], []]
    end

    @tag :prelude
    test "list" do
      file = "test/fixtures/prelude/list.sea"

      assert SeaC.Runner.run(file) == [1, 2, :պնդուկ, [1, 2]]
    end

    @tag :prelude
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
