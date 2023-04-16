defmodule SeaC.Tokenizer do
  def tokenize(input) do
    input
    |> insulate_parenthesis
    |> String.graphemes()
    |> tokenize("", [])
  end

  def tokenize([], partial, tokens) do
    case partial do
      "" -> tokens
      _ -> tokens ++ [partial]
    end
  end

  def tokenize([first | rest], partial, tokens) do
    case first do
      # parenthesis
      "(" -> tokenize(rest, "", tokens ++ [first])
      ")" -> tokenize(rest, "", tokens ++ [first])
      # strings
      "\"" -> parse_string(rest, first, tokens)
      # whitespaces
      " " when partial == "" -> tokenize(rest, "", tokens)
      "\n" when partial == "" -> tokenize(rest, "", tokens)
      "\t" when partial == "" -> tokenize(rest, "", tokens)
      " " -> tokenize(rest, "", tokens ++ [partial])
      "\n" -> tokenize(rest, "", tokens ++ [partial])
      "\t" -> tokenize(rest, "", tokens ++ [partial])
      # the generic case
      _ -> tokenize(rest, partial <> first, tokens)
    end
  end

  def parse_string([first | rest], partial, tokens, previous \\ "") do
    case first do
      "\\" -> parse_string(rest, partial <> first, tokens, first)
      "\"" when previous == "\\" -> parse_string(rest, partial <> first, tokens)
      "\"" -> tokenize(rest, "", tokens ++ [partial <> first])
      _ -> parse_string(rest, partial <> first, tokens)
    end
  end

  def insulate_parenthesis(input) do
    input
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
  end
end
