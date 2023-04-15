defmodule SeaC do
  def tokenize(input) do
    input
    |> normalize
    |> String.graphemes()
    |> tokenize("", [])
    |> Enum.reject(&(&1 == ""))
  end

  def tokenize([], partial, tokens) do
    tokens ++ [partial]
  end

  def tokenize([first | rest], partial, tokens) do
    case first do
      "(" -> tokenize(rest, "", tokens ++ [first])
      ")" -> tokenize(rest, "", tokens ++ [first])
      " " -> tokenize(rest, "", tokens ++ [partial])
      "\n" -> tokenize(rest, "", tokens ++ [partial])
      "\t" -> tokenize(rest, "", tokens ++ [partial])
      _ -> tokenize(rest, partial <> first, tokens)
    end
  end

  def normalize(input) do
    input
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
  end
end
