# Sea 🌊

[![seac tests](https://github.com/amuradyan/sea/actions/workflows/main.yml/badge.svg)](https://github.com/amuradyan/sea/actions/workflows/main.yml)

This is Sea, a [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language))-like language implemented in [Elixir](https://elixir-lang.org/), and I will be shaping this language as I go, trying to ergonomically incorporate the ideas I find important. Among these the most prevalent are perhaps the ability to *speak of the domain* and *reason about composition soundness*, provided, typically, by the type systems, the idea of tests being integral to software development, modularity and concurrency.

I plan to play with continuations and the concurrency of Elixir, the idea of composition via pipelines along with the idea of a computation that can fail or succeed in an environment, as in [ZIO](https://zio.dev/), try out some non-nomitaive static typing...

The possibilities are endless.

The name for the language is intentionally chosen to be a homophone to the [C language](https://en.wikipedia.org/wiki/C_(programming_language)), to spread confusion amongst those discussing it.

You can browse the [fixtures](./seac/test/fixtures/) for some Sea examples. Below are a few programms, just to give you a taste.

#### Length of a list via recursive definition \ [`length.sea`](./seac/test/fixtures/length.sea)

```lisp
( ; length of a list
  (define fruits (quote (apple pineapple pie)))
  (define length
    (lambda (list)
      (cond
        ((null? list) 0)
        (else (+ 1 (length (cdr list)))))))

  (length fruits))
```

#### Length of a list via the [Y combinator](https://en.wikipedia.org/wiki/Fixed-point_combinator#Y_combinator) \ [`length-y.sea`](./seac/test/fixtures/length-y.sea)

```lisp
(((lambda (le) ; setting up with Y combinator
    ((lambda (f) (f f))
     (lambda (f)
      (le (lambda (x) ((f f) x))))))
  (lambda (length) ; calculating the length of a list
        (lambda (l)
          (cond
            ((null? l) 0)
            (else (+ 1 (length (cdr l)))))))) (quote (apple pineapple pie)))
```

## Build and run

TBD
