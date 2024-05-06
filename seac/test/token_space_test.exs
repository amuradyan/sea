defmodule SeaC.TokenSpaceTests do
  alias SeaC.TokenSpace
  use ExUnit.Case

  test "that we are able to create an empty TokenSpace" do
    assert TokenSpace.new() == %TokenSpace{elements: [[]]}
  end

  test "that we can squash the top of the TokenSpace" do
    token_space = %TokenSpace{elements: [[1, 2, 3], [4, 5]]}
    squashed_token_space = %TokenSpace{elements: [[4, 5, [1, 2, 3]]]}

    assert TokenSpace.squash(token_space) == squashed_token_space
  end

  test "that we can extend the TokenSpace" do
    token_space = %TokenSpace{elements: [[1]]}
    extended_token_space = %TokenSpace{elements: [[], [1]]}

    assert TokenSpace.extend(token_space) == extended_token_space
    assert TokenSpace.extend(TokenSpace.new()) == TokenSpace.new()
  end

  test "that we can append to the top list of the TokenSpace" do
    token_space = %TokenSpace{elements: [[9, 8], [1, 2, 3]]}
    appended_token_space = %TokenSpace{elements: [[9, 8, 4], [1, 2, 3]]}

    assert TokenSpace.append(token_space, 4) == appended_token_space
  end

  test "that we can pop from the TokenSpace" do
    token_space = %TokenSpace{elements: [[1, 2, 3], [4, 5]]}
    popped_token_space = %TokenSpace{elements: [[4, 5]]}

    assert TokenSpace.pop(token_space) == {[1, 2, 3], popped_token_space}
  end
end
