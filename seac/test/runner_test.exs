defmodule SeaC.RunnerTests do
  use ExUnit.Case

  @tag one: true
  test "that we can run a Sea file" do
    file = "test/fixtures/ping.sea"

    assert SeaC.Runner.run(file) == [:"ճպուռ", 1]
  end
end
