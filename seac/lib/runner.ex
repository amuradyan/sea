defmodule SeaC.Runner do
  alias SeaC.Evaluator
  alias SeaC.Tokenizer

<<<<<<< HEAD
  def run(file) do
    {:ok, symbols} = File.read(file)

<<<<<<< HEAD
    Tokenizer.tokenize(symbols).elements
    # this should not be here
    |> hd()
    |> Tokenizer.remove_parens()
=======
  def run(symbols) do
    Tokenizer.process(symbols)
>>>>>>> b761346 (feat: running Sea more conveniently)
=======
    Tokenizer.process(symbols)
>>>>>>> ccf68e4 (feat: convenient symbol processing with tokenizer)
    |> Evaluator.value()
  end

  def run_file(file) do
    {:ok, symbols} = File.read(file)

    run(symbols)
  end
end
