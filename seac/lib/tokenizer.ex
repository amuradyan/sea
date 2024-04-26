defmodule SeaC.Tokenizer do
  def tokenize(input) do
    input
    |> insulate_parenthesis
    |> String.graphemes()
    |> tokenize("", [])
  end

  def remove_parens(tokens) do
    cond do
      tokens == [] -> []
      is_list(tokens) && (hd(tokens) == :"(" || hd(tokens) == :")") ->
        remove_parens(tl(tokens))
      is_list(tokens) && is_list(hd(tokens)) ->
        [remove_parens(hd(tokens)) | remove_parens(tl(tokens))]
      true -> [hd(tokens) | remove_parens(tl(tokens))]
    end
  end

  def tokenize([], "", tokens) do tokens end

  def tokenize([], partial, tokens) do tokens ++ [String.to_atom(partial)] end

  def tokenize([first | rest], partial, tokens) do
    case first do
      # parenthesis
      "(" ->
        {[_ | expression], tail} = split_expression([first | rest])
        expression_tokens = tokenize(expression, "", [])
        tokenize(tail, "", tokens ++ [[String.to_atom(first) | expression_tokens]])
      # strings
      "\"" -> parse_string(rest, first, tokens)
      # whitespaces
      " " when partial == "" -> tokenize(rest, "", tokens)
      "\n" when partial == "" -> tokenize(rest, "", tokens)
      "\t" when partial == "" -> tokenize(rest, "", tokens)
      " " -> tokenize(rest, "", tokens ++ [String.to_atom(partial)])
      "\n" -> tokenize(rest, "", tokens ++ [String.to_atom(partial)])
      "\t" -> tokenize(rest, "", tokens ++ [String.to_atom(partial)])
      # the generic case
      _ -> tokenize(rest, partial <> first, tokens)
    end
  end

  def parse_string(input, partial, tokens, previous \\ "")

  def parse_string([], partial, tokens, _) do tokens ++ [String.to_atom(partial)] end

  def parse_string([first | rest], partial, tokens, previous) do
    case first do
      "\\" -> parse_string(rest, partial <> first, tokens, first)
      "\"" when previous == "\\" -> parse_string(rest, partial <> first, tokens)
      "\"" -> tokenize(rest, "", tokens ++ [String.to_atom(partial <> first)])
      _ -> parse_string(rest, partial <> first, tokens)
    end
  end

  def insulate_parenthesis(input) do
    input
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
  end

  def split_expression([]) do
    {[], []}
  end

  def split_expression([first | rest]) do
    split_expression(rest, 1, [first])
  end

  def split_expression([], _, accumulated_expression) do
    {accumulated_expression, []}
  end

  def split_expression(rest, 0, accumulated_expression) do
    {accumulated_expression, rest}
  end

  def split_expression([")" | rest], open_parens_count, accumulated_expression) do
    split_expression(rest, open_parens_count - 1, accumulated_expression ++ [")"])
  end

  def split_expression(["(" | rest], open_parens_count, accumulated_expression) do
    split_expression(rest, open_parens_count + 1, accumulated_expression ++ ["("])
  end

  def split_expression([first | rest], open_parens_count, accumulated_expression) do
    split_expression(rest, open_parens_count, accumulated_expression ++ [first])
  end

end
