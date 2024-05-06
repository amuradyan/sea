defmodule SeaC.TokenSpace do
  alias SeaC.TokenSpace

  @type t :: %TokenSpace{elements: [any]}
  defstruct elements: []

  @spec new() :: TokenSpace.t()
  def new do
    %TokenSpace{elements: [[]]}
  end

  @spec squash(TokenSpace.t()) :: TokenSpace.t()
  def squash(token_space) do
    case token_space.elements do
      [singleton] ->
        %TokenSpace{elements: [singleton]}

      [first | [next | rest]] ->
        %TokenSpace{elements: [next ++ [first]] ++ rest}
    end
  end

  @spec pop(TokenSpace.t()) :: {TokenSpace.t(), any()}
  def pop(token_space) do
    case token_space.elements do
      [first | rest] -> {first, %TokenSpace{elements: rest}}
      _ -> []
    end
  end

  @spec extend(TokenSpace.t()) :: TokenSpace.t()
  def extend(token_space) do
    case token_space.elements do
      [[]] -> token_space
      _ -> %TokenSpace{elements: [[]] ++ token_space.elements}
    end
  end

  @spec append(TokenSpace.t(), any()) :: TokenSpace.t()
  def append(token_space, item) do
    case token_space.elements do
      [first | rest] ->
        %TokenSpace{elements: [first ++ [item]] ++ rest}

      _ ->
        %TokenSpace{elements: [[item]]}
    end
  end
end
