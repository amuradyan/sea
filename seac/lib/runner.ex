defmodule SeaC.Runner do
  alias SeaC.Evaluator
  alias SeaC.Tokenizer

  def run(file) do
    {:ok, symbols} = File.read(file)

    Tokenizer.process(symbols)
    |> Evaluator.value()
  end
end
