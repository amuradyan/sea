defmodule SeaC.RunnerTests do
  use ExUnit.Case

  test "that we can run a Sea file" do
    file = "test/fixtures/length-y.sea"

    assert SeaC.Runner.run(file) == 3
  end
end
