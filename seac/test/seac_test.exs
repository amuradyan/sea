defmodule SeaCTest do
  use ExUnit.Case

  test "should be able to split a string into tokens" do
    input = "(one two\nthree\tfour)"

    assert SeaC.tokenize(input) == ["(", "one", "two", "three", "four", ")"]
  end

  test "should consider a whitespace as a token separator" do
    input = "one two three"

    assert SeaC.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a newline as a token separator" do
    input = "one\ntwo\nthree"

    assert SeaC.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a tab as a token separator" do
    input = "one\ttwo\tthree"

    assert SeaC.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider an open parenthesis as a token" do
    input = "(one"

    assert SeaC.tokenize(input) == ["(", "one"]
  end

  test "should consider a close parenthesis as a token" do
    input = "one)"

    assert SeaC.tokenize(input) == ["one", ")"]
  end

  test "should wrap open parenthesis in spaces" do
    input = "(one"

    assert SeaC.normalize(input) == " ( one"
  end

  test "should wrap close parenthesis in spaces" do
    input = "one)"

    assert SeaC.normalize(input) == "one ) "
  end
end
