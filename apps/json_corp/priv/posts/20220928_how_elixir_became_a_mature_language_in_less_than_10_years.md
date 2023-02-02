%{
title: "Elixir 는 어떻게 10년도 안되어 성숙한 언어가 되었나",
description: "Elixir v2.0 계획이 없는 이유",
category: "dev",
cover_url: "https://json.media/images/blog/20220928_cover.png",
tags: ["개발", "Elixir"]
}

---

[지난 글](https://json.media/blog/elixir_1_14_dbg)에서 Elixir 는 v1.9 에서 마지막으로 예정되어있던 기능을 완성했다고 언급했었다.

> "Releases was the last planned feature for Elixir. We don’t have any major user-facing feature in the works nor planned."
>
> \- José Valim [1](https://elixir-lang.org/blog/2019/06/24/elixir-v1-9-0-released/)

오늘은 어떻게 2011년부터 만들기 시작한 언어가 10년도 되지 않은 2019년에 더 이상 만들어야하는 기능이 없다고 선언할 수 있었는지 얘기해보려 한다.

## 언어들의 나이

먼저 비교를 위해 다른 언어들은 나이가 어느 정도 되는지 알아보자. 우리가 흔히 알고 있는 언어들은 언제 만들어졌을까?

- C++: 1985년
- Python: 1991년
- Java: 1995년
- Javascript: 1995년
- Ruby: 1995년

다들 만들어진지 25년이 넘었지만, 아직도 계속 major version 을 업데이트하며 새로운 기능들을 확장해나가고 있다. 이렇게 비교해보면 Elixir 가 얼마나 어린 언어인지 알 수 있다.

<br>

Elixir 가 빠르게 성숙한 언어가 될 수 있었던 이유는 아래 두 가지로 말할 수 있을 것 같다.

## Elixir 는 Erlang 을 레버리징 한다

Elixir 는 1986년에 만들어진 Erlang 을 기반으로 하고 있다.

Erlang 은 concurrent, distributed, fault-tolerant 등을 특징으로 Ericsson 에서 수십년간 검증된 battle-tested language [2](https://www.erlang.org/about) 이기 때문에, Elixir 는 많은 시행착오들을 피해 빠르게 완성도가 높아질 수 있었다.

예를 들어 Elixir 의 문자열 처리는 Erlang 이 오랜 시간 진화해온 결과를 이어 받았기 때문이다. [3]

또한 지금도 계속해서 발전하는 Erlang 의 runtime 과 VM 의 덕을 보고 있다.

## Elixir 는 적은 공리를 가지고 있다

[Keywords](https://github.com/e3b0c442/keywords) 에 따르면 Elixir 는 reserved word 가 15 개로 [4](https://hexdocs.pm/elixir/1.14.0/syntax-reference.html#reserved-words), 조사된 언어 중 가장 적다.

Java 17 은 67 개, Python 3 는 38 개로, Elixir 가 압도적으로 적은 reserved words 로 이루어져있음을 알 수 있다.

reserved word 가 적다는 것은 언어가 간결하다는 것을 나타내는 지표 중 하나이다. 폴 그레이엄(Paul Graham)은 저서 <해커와 화가>(원저: Hackers & Painters) 에서 이렇게 말한다.

> 모든 프로그래밍 언어는 두 개의 부분으로 나누어질 수 있다. 공리의 역할을 담당하는 기본 연산자 집합과, 이러한 연산자를 이용해서 작성할 수 있는 언어의 나머지 부분이 그것이다.
> 내가 보기에 언어의 기본 연산자는 그 언어의 장기적인 사활에 가장 중요한 요소다. 나머지는 얼마든지 바꿀 수 있다.
>
> ... 공리는 잘 선택하는 것만으로는 부족하고, 수도 적어야 한다.
>
> ... 진화 나무의 중심 줄기는 가장 작고 깔끔한 중심부를 가지고 있는 언어를 관통할 것이라는 생각이 든다. 그 안에서 프로그램을 많이 작성할 수 있을수록 더 좋은 언어이기 때문이다.
>
> \- <해커와 화가> - 11. 100년 후의 프로그래밍 언어 중

Elixir 는 매우 적은 공리로 이루어진 언어이다. 예를 들면 아래와 같이 함수를 선언하는 `def` keyword 마저도 reserved word 가 아니어서, 프로그래머가 변경해서 사용할 수 있다. Javascript 로 치면 `function` keyword 를 내가 변경할 수 있다는 이야기다.

```elixir
defmodule MyModule do
  def add(a, b) do
    a + b
  end
end
```

이렇게 적은 공리는 뛰어난 확장성으로 이어진다. 그래서 다른 언어에서는 많은 것들을 언어 자체에서 지원해주지 않아 포기해야하는 것과 달리, Elixir 에서는 프로그래머가 하고자 하는 것을 직접 구현해서 해결할 수 있는 경우가 많다.\
(이는 Elixir 가 만들어질 때부터 Stability, Extensibility 를 중요시 해왔기 때문이다. [5](https://youtu.be/oUZC1s1N42Q?t=1497))

이를 역으로 얘기하면, Elixir 는 새로운 기능을 추가하기 위해 언어 자체가 바뀌어야 할 필요가 다른 언어에 비해 매우 적다는 얘기가 된다.

<br>

이러한 특징들로 인해 Elixir 는 10년도 되지 않아 더 이상 해야할 것이 없는 성숙한 언어가 되었다. 물론 이것은 언어 자체에 대한 이야기이며, DX/생태계의 발전이나, Machine Learning, Data Science 분야로의 확장 등 재밌는 일들이 매우 활발히 일어나고 있다.\
(예를 들어, Elixir 의 `Nx` 로 porting 한 k-means algorithm 은 Python 의 sklearn 보다 4배 이상 빠른 결과를 보였다고 한다.
(https://twitter.com/josevalim/status/1565408635961884673))

언어의 발전이 없이도 발전이 기대되는 언어라니 재밌지 않은가.

[3]: <Programming Elixir 1.6> p.132
