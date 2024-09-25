defmodule SeaC.PreludeTests do
  use ExUnit.Case

  @tag :prelude
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
<<<<<<< HEAD
=======
    test "fold" do
      file = "test/fixtures/prelude/fold.sea"

      assert SeaC.Runner.run_file(file) == [6, 0]
    end

    @tag :prelude
>>>>>>> b761346 (feat: running Sea more conveniently)
    test "contains" do
      file = "test/fixtures/prelude/contains.sea"

      assert SeaC.Runner.run_file(file) == [false, true, false]
    end

    @tag :prelude
    test "fold" do
      file = "test/fixtures/prelude/fold.sea"

<<<<<<< HEAD
      assert SeaC.Runner.run(file) == [6, 0]
=======
      assert SeaC.Runner.run_file(file) == [[1, 2, 3, 4], [1, 2], [1, 2], []]
    end

    @tag :prelude
    test "union" do
      file = "test/fixtures/prelude/union.sea"

      assert SeaC.Runner.run_file(file) == [[1, 3], [2], [4], []]
>>>>>>> b761346 (feat: running Sea more conveniently)
    end

    @tag :prelude
    test "append" do
      file = "test/fixtures/prelude/append.sea"

      assert SeaC.Runner.run(file) == [[1, 2, 3, 4], [1, 2], [1, 2], []]
    end

    @tag :prelude
    test "union" do
      file = "test/fixtures/prelude/union.sea"

      assert SeaC.Runner.run(file) == [[1, 3], [2], [4], []]
    end
  end
end
