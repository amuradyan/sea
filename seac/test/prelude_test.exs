defmodule SeaC.PreludeTests do
  use ExUnit.Case

  describe "Prelude" do
    @tag :prelude
    test "map" do
      file = "test/fixtures/prelude/map.sea"

      assert SeaC.Runner.run_file(file) == [[2, 3, 4], []]
    end

    @tag :prelude
    test "list" do
      file = "test/fixtures/prelude/list.sea"

      assert SeaC.Runner.run_file(file) == [1, 2, :պնդուկ, [1, 2]]
    end

    @tag :prelude
    test "identity" do
      file = "test/fixtures/prelude/identity.sea"

      assert SeaC.Runner.run_file(file) == [
               [],
               :ճպուռ,
               [:մատակ],
               [:մրջյուն, :թրթուռ]
             ]
    end

    @tag :prelude
    test "fold" do
      file = "test/fixtures/prelude/fold.sea"

      assert SeaC.Runner.run_file(file) == [6, 0]
    end

    @tag :prelude
    test "contains" do
      file = "test/fixtures/prelude/contains.sea"

      assert SeaC.Runner.run_file(file) == [false, true, false]
    end

    test "append" do
      file = "test/fixtures/prelude/append.sea"

      assert SeaC.Runner.run_file(file) == [[1, 2, 3, 4], [1, 2], [1, 2], []]
    end

    @tag :prelude
    test "union" do
      file = "test/fixtures/prelude/union.sea"

      assert SeaC.Runner.run_file(file) == [[1, 3], [2], [4], []]
    end

    @tag :prelude
    test "difference" do
      file = "test/fixtures/prelude/difference.sea"

      assert SeaC.Runner.run_file(file) == [[1, 2], [3], [], []]
    end
  end
end
