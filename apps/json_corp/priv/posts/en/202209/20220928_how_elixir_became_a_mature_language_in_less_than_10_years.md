%{
title: "How Elixir became a mature language in less than 10 years",
description: "Elixir has no plans for v2.0",
category: "dev",
cover_url: "/images/blog/20220928_cover.png",
tags: ["dev", "Elixir"]
}

---

José Valim, the creator of the Elixir language, mentioned that they had completed the last scheduled feature in Elixir v1.9.

> "Releases was the last planned feature for Elixir. We don’t have any major user-facing feature in the works nor planned."
>
> \- José Valim [1](https://elixir-lang.org/blog/2019/06/24/elixir-v1-9-0-released/)

In this post, I'm going to talk about how a language that began development in 2011 could declare, less than a decade later, that there were no more features left to be built.

## Age of Languages

First, let's compare by looking at the ages of other languages. When were the languages we know today created?

- C++: 1985
- Python: 1991
- Java: 1995
- Javascript: 1995
- Ruby: 1995

All of them are over 25 years old, yet they continue to release major versions and introduce new features. This underscores just how young Elixir is in comparison.

<br>

There are two main reasons why Elixir has become a mature language so quickly.

## Elixir leverages Erlang

Elixir is based on Erlang, which was created in 1986.

Because Erlang is a battle-tested langauge[2](https://www.erlang.org/about) that has been proven over decades at Ericsson, boasting features such as concurrent, distributed, and fault-tolerant, Elixir was able to bypass much of the trial and error and rapidly achieve maturity.

For example, "String handling in Elixir is the result of a long evolutionary process in the underlying Erlang environment."[3]

It also benefit from the ever-improving Erlang runtime and VM.

## Elixir has a minimal set of axioms

According to [Keywords](https://github.com/e3b0c442/keywords), **Elixir has only 15 reserved words**[4](https://hexdocs.pm/elixir/1.14.0/syntax-reference.html#reserved-words), the the fewest among the languages surveyed.

With Java 17 having 67 and Python 3 having 38, it's evident that Elixir is comprised of a significantly smaller number of reserved words.

A smaller number of reserved words is one indicator of a language's simplicity. Paul Graham remarks on this in his book, 'Hackers & Painters':

> Any programming language can be divided into two parts: some set of fundamental operators that play the role of axioms, and the rest of the language, which could in principle be written in terms of these fundamental operators.
> I think the fundamental operators are the most important factor in a language’s long term survival. The rest you can change.
> ...
> It’s important not just that the axioms be well chosen, but that there be few of them.
> ...
> I have a hunch that the main branches of the evolutionary tree pass through the languages that have the smallest, cleanest cores. The more of a language you can write in itself, the better.
>
> \- <Hackers & Painters> - 11. The Hundred-Year Language

Elixir is a language constructed with a very minimal set of axioms. For instance, even the `def` keyword, which is used to declare functions, is not a reserved word, allowing programmers to modify it. To put it in JavaScript terms, it's like being able to change the `function` keyword.

```elixir
defmodule MyModule do
  def add(a, b) do
    a + b
  end
end
```

Such a limited set of axioms leads to exceptional extensibility. Thus, unlike in other languages where many things aren't supported natively and have to be foregone, in Elixir, there are many cases where programmers can implement and address what they want directly.\
This is because, Elixir has focused on Stability and Extensibility.[5](https://youtu.be/oUZC1s1N42Q?t=1497)

Conversely, this means that Elixir requires far fewer changes at the language level to introduce new features compared to other languages.

---

Due to these characteristics, Elixir became a mature language in less than a decade, feeling complete with no further essentials to add. Based on this foundation, there are indeed vibrant activities unfolding in enhancing developer experience, ecosystem growth, and expansion into fields like Machine Learning and Data Science.

For instance, it's said that the k-means algorithm ported with Elixir's [`Nx`](https://github.com/elixir-nx/nx/tree/main/nx#readme) demonstrated results more than 4 times faster than Python's sklearn.[6](https://twitter.com/josevalim/status/1565408635961884673)

Isn't it intriguing that a language can be anticipated to progress even without its own evolution?

[3]: <Programming Elixir 1.6> p.132
