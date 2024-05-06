defmodule SeaC.Runner do
  alias SeaC.Evaluator
  alias SeaC.Tokenizer

  def run(file) do
    {:ok, symbols} = File.read(file)

    Tokenizer.tokenize(symbols).elements
    # this should not be here
    |> hd()
    |> Tokenizer.remove_parens()
    |> Evaluator.value()
  end
end
