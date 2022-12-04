%{
title: "Doumi.Phoenix.SVG is published",
description: "Phoenix 에서 SVG 를 가장 깔끔하게 사용하는 방법",
category: "dev"
}

---

Momenti 에 있을 당시 [경열님](https://github.com/chitacan)이 만드셨던 module 을 토대로 [Doumi.Phoenix.SVG]를 만들었다.

HTML 안에서 `<svg>` 태그를 직접 사용하는 것이 여러모로 좋은 점들이 있지만, HTML 을 보기 힘들게 만든다는 단점이 있다. 이러한 단점은 특히 Phoenix LiveView 에서 HTML 코드를 Elixir 코드 안에서 같이 사용할 때 두드러진다.

```elixir
defmodule MyAppWeb.PageLive do
  ...

  def render(assigns) do
    ~H"""
    <div>
      <svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Elixir</title><path d="M19.793 16.575c0 3.752-2.927 7.426-7.743 7.426-5.249 0-7.843-3.71-7.843-8.29 0-5.21 3.892-12.952 8-15.647a.397.397 0 0 1 .61.371 9.716 9.716 0 0 0 1.694 6.518c.522.795 1.092 1.478 1.763 2.352.94 1.227 1.637 1.906 2.644 3.842l.015.028a7.107 7.107 0 0 1 .86 3.4z"/></svg>
    </div>
    """
  end
end
```

이를 해당 `<svg>` 태그를 Phoenix function component 로 분리하고 해당 component 를 사용하는 방식으로 해결할 수 있지만, 각 svg 를 하나하나 Phoenix function component 로 변환하는 작업은 귀찮다.

```elixir
defmodule MyAppWeb.Icon do
  use Phoenix.Component

  def github(assigns) do
    ~H"""
    <svg {assigns} role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Elixir</title><path d="M19.793 16.575c0 3.752-2.927 7.426-7.743 7.426-5.249 0-7.843-3.71-7.843-8.29 0-5.21 3.892-12.952 8-15.647a.397.397 0 0 1 .61.371 9.716 9.716 0 0 0 1.694 6.518c.522.795 1.092 1.478 1.763 2.352.94 1.227 1.637 1.906 2.644 3.842l.015.028a7.107 7.107 0 0 1 .86 3.4z"/></svg>
    """
  end
end

defmodule MyAppWeb.PageLive do
  ...

  alias MyAppWeb.Icon
  def render(assigns) do
    ~H"""
    <div>
      <Icon.github />
    </div>
    """
  end
end
```

이러한 귀찮음을 제거하기 위해 저장된 svg 를 파일들을 compile time 에 읽어와 자동으로 Phoenix function component 로 만들어주는 [Doumi.Phoenix.SVG] 를 만들었다.

```elixir
defmodule MyAppWeb.Icon do
  use Phoenix.Component, path: "priv/icons"
end

defmodule MyAppWeb.PageLive do
  ...

  alias MyAppWeb.Icon
  def render(assigns) do
    ~H"""
    <div>
      <Icon.github />
    </div>
    """
  end
end
```

지금까지 만든 open source library 중에는 가장 쓸만한 것 같은데 과연?

[Doumi.Phoenix.SVG] 를 사용한 예제는 [이 commit](https://github.com/nallwhy/json_corp/commit/80fd9d40104d811de26d6abc5adc20a9911d241d) 에서 확인할 수 있다.

### 자매품

- [Doumi.URI.Query](https://json.media/blog/doumi_uri_query_is_published): Nested map, list 를 URI query string 으로 encoding 하는 방법

[Doumi.Phoenix.SVG]: https://github.com/nallwhy/doumi_phoenix_svg
