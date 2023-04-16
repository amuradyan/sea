defmodule SeaC.TokenizerTests do
  use ExUnit.Case

  test "should be able to split a string into tokens" do
    input = "(one two\nthree\tfour)"

    assert SeaC.Tokenizer.tokenize(input) == ["(", "one", "two", "three", "four", ")"]
  end

  test "should consider a space as a token separator" do
    input = "one two three"

    assert SeaC.Tokenizer.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a sequence of spaces as a single token separator" do
    input = "one    two     three"

    assert SeaC.Tokenizer.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a newline as a token separator" do
    input = "one\ntwo\nthree"

    assert SeaC.Tokenizer.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a sequence of newlines as a single token separator" do
    input = "one\n\ntwo\n\n\nthree"

    assert SeaC.Tokenizer.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a tab as a token separator" do
    input = "one\ttwo\tthree"

    assert SeaC.Tokenizer.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a sequence of tabs as a single token separator" do
    input = "one\t\ttwo\t\t\tthree"

    assert SeaC.Tokenizer.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider a sequence of whitespaces as a single token separator" do
    input = "one\t\t\n   two\n  \n \t  \nthree"

    assert SeaC.Tokenizer.tokenize(input) == ["one", "two", "three"]
  end

  test "should consider an open parenthesis as a token" do
    input = "(one"

    assert SeaC.Tokenizer.tokenize(input) == ["(", "one"]
  end

  test "should consider a close parenthesis as a token" do
    input = "one)"

    assert SeaC.Tokenizer.tokenize(input) == ["one", ")"]
  end

  test "should consider a line of only whitespaces as an empty list" do
    input = "   \t\t\n\n"

    assert SeaC.Tokenizer.tokenize(input) == []
  end

  test "should be able to tokenize a string literal" do
    input = """
    "one two three"
    """

    assert SeaC.Tokenizer.tokenize(input) == ["\"one two three\""]
  end

  test "should be able to tokenize a string literal with escaped characters" do
    input = """
    "one two \t three"
    """

    assert SeaC.Tokenizer.tokenize(input) == ["\"one two \t three\""]
  end

  test "should be able to handle escaped quotes in a string literal" do
    input = """
    "one two \\\"three\\\""
    """

    assert SeaC.Tokenizer.tokenize(input) == ["\"one two \\\"three\\\"\""]
  end

  test "should be able to tokenize a multiline string literal" do
    input = """
    "one
        two
        three"
    """

    assert SeaC.Tokenizer.tokenize(input) == [
             "\"one
    two
    three\""
           ]
  end

  test "should wrap open parenthesis in spaces" do
    input = "(one"

    assert SeaC.Tokenizer.insulate_parenthesis(input) == " ( one"
  end

  test "should wrap close parenthesis in spaces" do
    input = "one)"

    assert SeaC.Tokenizer.insulate_parenthesis(input) == "one ) "
  end
end
