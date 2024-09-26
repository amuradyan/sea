defmodule SeaC.Runner do
  alias SeaC.Evaluator
  alias SeaC.Tokenizer

  def run(symbols) do
    Tokenizer.process(symbols)
    |> Evaluator.value()
  end

  def run_file(file) do
    {:ok, symbols} = File.read(file)

    run(symbols)
  end
end
