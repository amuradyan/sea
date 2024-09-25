defmodule SeaC.TokenizerTests do
  alias SeaC.TokenSpace
  use ExUnit.Case

  @tag :tokenizer
  test "should be able to tokenize a valid Sea program" do
    {:ok, input} = File.read("test/fixtures/hello-world.sea")

    assert SeaC.Tokenizer.tokenize(input) ==
             %TokenSpace{
               elements: [
                 [
                   :"(",
                   :module,
                   :HelloWorld,
                   [:"(", :import, [:"(", :"IO:write/1", :")"], :")"],
                   [:"(", :write, :"\"Հելո, world!\"", :")"],
                   :")"
                 ]
               ]
             }
  end

  @tag :tokenizer
  test "that we ignore all the symbols till the end of the line after the semicolon" do
    input = """
    code ; this is a comment
    another_code
    """

    tokens = %TokenSpace{elements: [[:code, :another_code]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should be able to split a string into tokens" do
    input = "(one two\nthree\tfour)"

    tokens = %TokenSpace{
      elements: [[:"(", :one, :two, :three, :four, :")"]]
    }

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a space as a token separator" do
    input = "one two three"
    tokens = %TokenSpace{elements: [[:one, :two, :three]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a sequence of spaces as a single token separator" do
    input = "one    two     three"
    tokens = %TokenSpace{elements: [[:one, :two, :three]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a newline as a token separator" do
    input = "one\ntwo\nthree"
    tokens = %TokenSpace{elements: [[:one, :two, :three]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a sequence of newlines as a single token separator" do
    input = "one\n\ntwo\n\n\nthree"
    tokens = %TokenSpace{elements: [[:one, :two, :three]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a tab as a token separator" do
    input = "one\ttwo\tthree"
    tokens = %TokenSpace{elements: [[:one, :two, :three]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a sequence of tabs as a single token separator" do
    input = "one\t\ttwo\t\t\tthree"
    tokens = %TokenSpace{elements: [[:one, :two, :three]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a sequence of whitespaces as a single token separator" do
    input = "one\t\t\n   two\n  \n \t  \nthree"
    tokens = %TokenSpace{elements: [[:one, :two, :three]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider an open parenthesis as a token" do
    input = "(one"
    tokens = %TokenSpace{elements: [[:"(", :one]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a close parenthesis as a token" do
    input = "one)"
    tokens = %TokenSpace{elements: [[:one, :")"]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should consider a line of only whitespaces as an empty list" do
    input = "   \t\t\n\n"
    tokens = %TokenSpace{elements: [[]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should be able to tokenize a string literal" do
    input = """
    "one two three"
    """

    tokens = %TokenSpace{elements: [[:"\"one two three\""]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should be able to tokenize a string literal with escaped characters" do
    input = """
    "one two \t three"
    """

    tokens = %TokenSpace{elements: [[:"\"one two \t three\""]]}

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should be able to handle escaped quotes in a string literal" do
    input = """
    "one two \\\"three\\\""
    """

    tokens = %TokenSpace{
      elements: [[:"\"one two \\\"three\\\"\""]]
    }

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should be able to tokenize a multiline string literal" do
    input = """
    "one
        two
        three"
    """

    tokens = %TokenSpace{
      elements: [[:"\"one
    two
    three\""]]
    }

    assert SeaC.Tokenizer.tokenize(input) == tokens
  end

  @tag :tokenizer
  test "should wrap open parenthesis in spaces" do
    input = "(one"

    assert SeaC.Tokenizer.insulate_parenthesis(input) == " ( one"
  end

  @tag :tokenizer
  test "should wrap close parenthesis in spaces" do
    input = "one)"

    assert SeaC.Tokenizer.insulate_parenthesis(input) == "one ) "
  end

  @tag :tokenizer
  test "that we are able to get rid of the parens in in tokens" do
    raw_tokens =
      [
        :"(",
        :module,
        :HelloWorld,
        [:"(", :import, [:"(", :"IO:write/1", :")"], :")"],
        [:"(", :write, :"\"Հելո, world!\"", :")"],
        :")"
      ]

    sanitized_tokens =
      [
        :module,
        :HelloWorld,
        [:import, [:"IO:write/1"]],
        [:write, :"\"Հելո, world!\""]
      ]

    assert SeaC.Tokenizer.remove_parens(raw_tokens) == sanitized_tokens
    assert SeaC.Tokenizer.remove_parens([]) == []
    assert SeaC.Tokenizer.remove_parens([:a, :b, :c]) == [:a, :b, :c]
  end
end
