After a push on prelude, it now refers to other functions in prelude. For now I copy them around, marking the block with a comment `;IMPORT`. We need modularity.

-----

Also the sandbox test takes forever, 124 seconds. T should look into that.

-----

TIL: to profile you do `mix profile.eprof -e "SeaC.Evaluator.meaning([:+, :a, 1], [[a], [1]])"`. There are also `fprof` and `cprof`.
