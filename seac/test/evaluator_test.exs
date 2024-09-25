defmodule SeaC.EvaluatorTests do
  use ExUnit.Case

  alias SeaC.Evaluator
  alias SeaC.ReservedWords

  describe "Evaluator" do
    @tag :evaluator
    test "that we can extend the environment by defining names for values" do
      env = [[[:four], [4]]]
      x_as_1 = [:define, :x, :"1"]
      lambda = [:lambda, [:a, :b], [:+, :a, :b]]
      y_as_lambda = [:define, :y, lambda]
      value = [:"non-primitive", [env | tl(lambda)]]

      assert Evaluator.define(x_as_1, env) == [[[:x], [1]], [[:four], [4]]]
      assert Evaluator.define(y_as_lambda, env) == [[[:y], [value]], [[:four], [4]]]
    end

    @tag :evaluator
    test "that we understand the meaning of definitions" do
      env = []
      x_plus_1 = [[:define, :x, :"1"], [:+, :x, :"1"]]

      assert Evaluator.meaning(x_plus_1, env) == 2
    end

    @tag :evaluator
    test "that we regard the numbers as constants" do
      assert Evaluator.meaning(:"7", []) == 7
      assert Evaluator.meaning(:"7.7", []) == 7.7
    end

    @tag :evaluator
    test "that we regard the Booleans as constants" do
      assert Evaluator.meaning(true, []) == true
      assert Evaluator.meaning(false, []) == false
    end

    @tag :evaluator
    test "that we regard some words as constants" do
      actions_for_reserved_words =
        Enum.map(ReservedWords.all(), fn word -> Evaluator.meaning(word, []) end)

      expected_outcome =
        Enum.map(ReservedWords.values(), fn word -> word end) ++
          Enum.map(ReservedWords.primitives(), fn word -> [:primitive, word] end)

      assert (actions_for_reserved_words -- expected_outcome) |> Enum.empty?()
    end

    @tag :evaluator
    test "that we regard some expressions as identifiers" do
      identifier = :birthmarks
      env = [[[:scars, identifier], [4, :none]]]

      resolved_identifier = Evaluator.meaning(identifier, env)
      unresolved_identifier = Evaluator.meaning(:unknown, env)

      assert resolved_identifier == :none
      assert unresolved_identifier == "Unable to resolve unknown"
    end

    @tag :evaluator
    test "that we regard some expressions as atoms" do
      assert Evaluator.meaning([:quote, :this], []) == :this
      assert Evaluator.meaning([:quote, [:this, :as, :well]], []) == [:this, :as, :well]
    end

    @tag :evaluator
    test "that we regard some atoms as numbers" do
      assert Evaluator.meaning([:quote, :"2"], []) == 2
    end

    @tag :evaluator
    test "that we regard some expressions as anonymous functions" do
      env = []
      lambda = [:lambda, [:a, :b], [:+, :a, :b]]
      value = [:"non-primitive", [env | tl(lambda)]]

      assert Evaluator.meaning(lambda, env) == value
    end

    @tag :evaluator
    test "that we can interpret Sea functions as atoms" do
      assert Evaluator.atom?(true) == true
      assert Evaluator.atom?(:ping) == true
      assert Evaluator.atom?([]) == false
      assert Evaluator.atom?([:primitive, :function]) == true
      assert Evaluator.atom?([:"non-primitive", :function]) == true
    end

    @tag :evaluator
    test "that we are able to apply primitive functions" do
      assert Evaluator.apply_primitive(:cons, [1, [2]]) == [1, 2]
      assert Evaluator.apply_primitive(:cons, [1, 2]) == [1, 2]
      assert Evaluator.apply_primitive(:cons, [1, []]) == [1]
      assert Evaluator.apply_primitive(:cons, [[], []]) == [[]]
      assert Evaluator.apply_primitive(:cons, [[], 1]) == [[], 1]
      assert Evaluator.apply_primitive(:car, [[1]]) == 1
      assert Evaluator.apply_primitive(:cdr, [[1, 2]]) == [2]
      assert Evaluator.apply_primitive(:null?, [[]]) == true
      assert Evaluator.apply_primitive(:null?, [1, 2]) == false
      assert Evaluator.apply_primitive(:same?, [1, true]) == false
      assert Evaluator.apply_primitive(:same?, [[1], [1]]) == true
      assert Evaluator.apply_primitive(:same?, [:b, :b]) == true
      assert Evaluator.apply_primitive(:atom?, [:values]) == true
      assert Evaluator.apply_primitive(:atom?, [[]]) == false
      assert Evaluator.apply_primitive(:atom?, [true]) == true
      assert Evaluator.apply_primitive(:zero?, [0]) == true
      assert Evaluator.apply_primitive(:zero?, [1]) == false
      assert Evaluator.apply_primitive(:zero?, [:f]) == false
      assert Evaluator.apply_primitive(:number?, [7]) == true
      assert Evaluator.apply_primitive(:number?, [6.6]) == true
      assert Evaluator.apply_primitive(:number?, [[7]]) == false
      assert Evaluator.apply_primitive(:number?, [true]) == false
      b1 = 10_000_000_000_000_000_000_000_000_000_000_000_000
      b2 = 9_999_999_999_999_999_999_999_999_999_999_999_999
      assert Evaluator.apply_primitive(:+, [1, b2]) == b1
      assert Evaluator.apply_primitive(:-, [1, 2]) == -1
    end

    @tag :evaluator
    test "that we are able to find the meaning of a primitive" do
      env = [
        [[:list], [[1, [2]]]],
        [[:empty_list], [[]]],
        [[:t, :f], [true, false]],
        [[:b], [[2]]],
        [[:at], [:om]],
        [[:zro], [0]],
        [[:mek], [1]],
        [[:erku], [2]],
        [[:hing], [5]],
        [[:վեցուվեց], [6.6]],
        [[:ծիծիլյառդ], [10_000_000_000_000_000_000_000_000_000_000_000_000]]
      ]

      assert Evaluator.meaning([:cons, :"1", [:cons, :"2", [:quote, []]]], env) == [1, 2]
      assert Evaluator.meaning([:cons, :mek, :b], env) == [1, 2]
      assert Evaluator.meaning([:car, :list], env) == 1
      assert Evaluator.meaning([:cdr, :list], env) == [[2]]
      assert Evaluator.meaning([:null?, :empty_list], env) == true
      assert Evaluator.meaning([:null?, :list], env) == false
      assert Evaluator.meaning([:atom?, :at], env) == true
      assert Evaluator.meaning([:atom?, :list], env) == false
      assert Evaluator.meaning([:atom?, true], env) == true
      assert Evaluator.meaning([:zero?, :zro], env) == true
      assert Evaluator.meaning([:zero?, :mek], env) == false
      assert Evaluator.meaning([:zero?, false], env) == false
      assert Evaluator.meaning([:number?, :hing], env) == true
      assert Evaluator.meaning([:number?, :վեցուվեց], env) == true
      assert Evaluator.meaning([:number?, :list], env) == false
      assert Evaluator.meaning([:number?, true], env) == false
      ծիծիլյառդումեկ = 10_000_000_000_000_000_000_000_000_000_000_000_001
      իններ = 9_999_999_999_999_999_999_999_999_999_999_999_999
      assert Evaluator.meaning([:+, :ծիծիլյառդ, :mek], env) == ծիծիլյառդումեկ
      assert Evaluator.meaning([:-, :ծիծիլյառդ, :mek], env) == իններ
      assert Evaluator.meaning([:/, :mek, :erku, :erku], env) == 0.25
      assert Evaluator.meaning([:*, :hing, :erku, :erku], env) == 20
      assert Evaluator.meaning([:or, :t, :f], env) == true
      assert Evaluator.meaning([:or, :f, :f], env) == false
      assert Evaluator.meaning([:and, :t, :f], env) == false
      assert Evaluator.meaning([:and, :t, :t], env) == true
      assert Evaluator.meaning([:not, :t], env) == false
      assert Evaluator.meaning([:not, :f], env) == true
      assert Evaluator.meaning([:same?, :mek, :b], env) == false
      assert Evaluator.meaning([:same?, :mek, :mek], env) == true
      assert Evaluator.meaning([:lt?, :mek, :erku], env) == true
      assert Evaluator.meaning([:lt?, :mek, :mek], env) == false
      assert Evaluator.meaning([:lt?, :mek, :zro], env) == false
      assert Evaluator.meaning([:lte?, :mek, :erku], env) == true
      assert Evaluator.meaning([:lte?, :mek, :mek], env) == true
      assert Evaluator.meaning([:lte?, :mek, :zro], env) == false
      assert Evaluator.meaning([:gt?, :mek, :erku], env) == false
      assert Evaluator.meaning([:gt?, :mek, :mek], env) == false
      assert Evaluator.meaning([:gt?, :mek, :zro], env) == true
      assert Evaluator.meaning([:gte?, :mek, :erku], env) == false
      assert Evaluator.meaning([:gte?, :mek, :mek], env) == true
      assert Evaluator.meaning([:gte?, :mek, :zro], env) == true
      assert Evaluator.meaning([:ne?, :mek, :erku], env) == true
      assert Evaluator.meaning([:ne?, :mek, :mek], env) == false
    end

    @tag :evaluator
    test "that we can tell a primitive call from a non-primitive one and nest them" do
      closure_table = []
      closure_formals = [:x, :y]
      closure_body = [:cons, :"1", [:+, :x, :y]]

      closure = [closure_table, closure_formals, closure_body]

      assert Evaluator.apply_function([:"non-primitive", closure], [5, 8], []) == [1, 13]
    end

    @tag :evaluator
    test "that we are able to evaluate complex applications" do
      closure_formals = [:x, :y]
      closure_body = [:cons, [:+, :x, :y], :"1"]

      # check for invalid applications
      application = [[:lambda, closure_formals, closure_body], :"5", :"6"]

      assert Evaluator.application(application, []) == [11, 1]
    end

    @tag :evaluator
    test "that we are able to calculate the values of expressions" do
      program = [
        [
          [
            :lambda,
            [:պոպոկ],
            [
              :lambda,
              [:պնդուկ],
              [:cond, [[:same?, :պնդուկ, :"2"], [:quote, :ննդուկ]], [true, [:+, :պոպոկ, :"9"]]]
            ]
          ],
          :"1"
        ],
        :"3"
      ]

      assert Evaluator.value(:"4") == 4
      assert Evaluator.value(true) == true
      assert Evaluator.value([:+, :"8", :"8", :"8"]) == 24
      assert Evaluator.value([:-, :"8", :"8", :"8"]) == -8
      assert Evaluator.value([:/, :"4", :"2", :"2"]) == 1
      assert Evaluator.value(program) == 10
    end

    @tag :evaluator
    test "that we can evaluate a list" do
      env = [[[:x], [2]]]

      assert Evaluator.evaluate_list([[:quote, :mek], :x, :"3"], env) == [:mek, 2, 3]
      assert Evaluator.evaluate_list([], env) == []
    end

    @tag :evaluator
    test "that we gracefully handle unknown types of expressions" do
      assert Evaluator.meaning("des tination", []) == :unknown
    end

    @tag :evaluator
    test "that we are able to check whether an atom is a number" do
      assert Evaluator.number?(:"3") == true
      assert Evaluator.number?(:"3a") == false
    end

    @tag :evaluator
    test "that we are able to distinguish `else` clauses in conditions" do
      assert Evaluator.else_clause?([:else, [:body]]) == true
      assert Evaluator.else_clause?([:ololo, [:body]]) == false
      assert Evaluator.else_clause?([]) == false
    end

    @tag :evaluator
    test "that we can fall back to `else` clause, while evaluating the condition" do
      env = [[[:always, :one], [false, 1]]]

      false_clause = [:always, :unknown]
      else_clause = [:else, :one]

      assert Evaluator.evaluate_clauses([false_clause, else_clause], env) == 1
    end

    @tag :evaluator
    test "that we are able to evaluate condition clauses" do
      env = [[[:always, :sometimes, :two], [false, true, 2]]]

      false_clause = [:always, 1]
      true_clause = [:sometimes, :two]
      else_clause = [:else, 3]

      assert Evaluator.evaluate_clauses([false_clause, true_clause, else_clause], env) == 2
    end

    @tag :evaluator
    test "that we handle stubs properly" do
      program = [[:define, :stub, [:lambda, [:x], [:"???"]]], [:stub, :"1"]]

      assert_raise RuntimeError, fn -> Evaluator.value(program) end
    end
  end
end
