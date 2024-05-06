defmodule SeaC.RunnerTests do
  use ExUnit.Case

  test "that we can run a Sea file" do
    file = "test/fixtures/length-y.sea"

    assert SeaC.Runner.run(file) == 3
  end

  test "that we can understand a definition in a function" do
    file = "test/fixtures/definitions/define-in-a-function.sea"

    assert SeaC.Runner.run(file) == 6
  end
end
