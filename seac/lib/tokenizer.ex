defmodule SeaC.Tokenizer do
  alias SeaC.TokenSpace

  def tokenize(input) do
    input
    |> insulate_parenthesis
    |> String.graphemes()
    |> tokenize("", TokenSpace.new())
  end

  def remove_parens(tokens) do
    cond do
      tokens == [] ->
        []

      is_list(tokens) && (hd(tokens) == :"(" || hd(tokens) == :")") ->
        remove_parens(tl(tokens))

      is_list(tokens) && is_list(hd(tokens)) ->
        [remove_parens(hd(tokens)) | remove_parens(tl(tokens))]

      true ->
        [hd(tokens) | remove_parens(tl(tokens))]
    end
  end

  def tokenize([], "", tokens) do
    tokens
  end

  def tokenize([], partial, tokens) do
    TokenSpace.append(tokens, String.to_atom(partial))
  end

  def tokenize([first | rest], partial, tokens) do
    case first do
      # parens
      "(" ->
        extended_tokens =
          tokens
          |> TokenSpace.extend()
          |> TokenSpace.append(String.to_atom(first))

        tokenize(rest, "", extended_tokens)

      ")" ->
        squashed_tokens =
          tokens
          |> TokenSpace.append(String.to_atom(first))
          |> TokenSpace.squash()

        tokenize(rest, "", squashed_tokens)

      # strings
      "\"" ->
        parse_string(rest, first, tokens)

      # whitespaces
      " " when partial == "" ->
        tokenize(rest, "", tokens)

      "\n" when partial == "" ->
        tokenize(rest, "", tokens)

      "\t" when partial == "" ->
        tokenize(rest, "", tokens)

      " " ->
        tokenize(rest, "", TokenSpace.append(tokens, String.to_atom(partial)))

      "\n" ->
        tokenize(rest, "", TokenSpace.append(tokens, String.to_atom(partial)))

      "\t" ->
        tokenize(rest, "", TokenSpace.append(tokens, String.to_atom(partial)))

      # comments
      ";" when partial == "" ->
        next = Enum.drop_while(rest, fn char -> char != "\n" end)
        tokenize(next, "", tokens)

      # the generic case
      _ ->
        tokenize(rest, partial <> first, tokens)
    end
  end

  def parse_string(input, partial, tokens, previous \\ "")

  def parse_string([], partial, tokens, _) do
    TokenSpace.append(tokens, String.to_atom(partial))
  end

  def parse_string([first | rest], partial, tokens, previous) do
    case first do
      "\\" -> parse_string(rest, partial <> first, tokens, first)
      "\"" when previous == "\\" -> parse_string(rest, partial <> first, tokens)
      "\"" -> tokenize(rest, "", TokenSpace.append(tokens, String.to_atom(partial <> first)))
      _ -> parse_string(rest, partial <> first, tokens)
    end
  end

  def insulate_parenthesis(input) do
    input
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
  end
end
