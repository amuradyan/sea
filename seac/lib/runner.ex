defmodule SeaC.Runner do
  alias SeaC.Evaluator
  alias SeaC.Tokenizer

  def run(file) do
    {:ok, symbols} = File.read(file)

    IO.inspect(symbols)

    symbols
      |> Tokenizer.tokenize
      |> hd # this should not be here
      |> Tokenizer.remove_parens
      |> Evaluator.value
  end
end
