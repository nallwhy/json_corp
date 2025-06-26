%{
title: "Doumi.URI.Query is published",
description: "map, list query string encoding 지원",
category: :dev,
tags: ["개발", "Elixir", "Open Source", "Library"]
}

---

[Doumi.URI.Query] 는 nested map, list 를 URI query string 으로 encoding 해주는 library 이다.

이번에 Stripe API 를 사용하면서 nested map, list 를 URI query string 으로 변환해서 보내야 할 필요성이 있었다.  
하지만 Elixir 의 공식 함수인 [`URI.encode_query/2`](https://hexdocs.pm/elixir/1.14.2/URI.html#encode_query/2) 는 nested map, list 를 encoding 의 대상으로 허용하지 않는데, 이유는 이에 대한 표준화된 방법이 존재하지 않기 때문이다.  
그래서 각 언어나 framework, 심지어 API 별로 이를 수행하는 방식이 다 다르다.

일단은 가장 많이 사용되는 PHP style 의 방법을 지원하도록 작성하였다.

```elixir
iex> query = %{"foo" => %{"bar" => 1, "baz" => 2}}
iex> Doumi.URI.Query.encode(query)
"foo%5Bbar%5D=1&foo%5Bbaz%5D=2" # foo[bar]=1&foo[baz]=2

iex> query = %{"foo" => [1, 2, 3]}
iex> Doumi.URI.Query.encode(query)
"foo%5B%5D=1&foo%5B%5D=2&foo%5B%5D=3" # foo[]=1&foo[]=2&foo[]=3
```

꽤 간단하게 잘 작성한듯?

### 자매품

- [Doumi.Phoenix.SVG](./doumi-phoenix-svg-is-published): Phoenix 에서 SVG 를 가장 깔끔하게 사용하는 방법

[Doumi.URI.Query]: https://github.com/nallwhy/doumi_uri_query
