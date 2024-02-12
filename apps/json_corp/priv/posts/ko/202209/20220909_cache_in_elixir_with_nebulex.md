%{
title: "Elixir 에서 Nebulex 로 cache 설정하기",
description: "앗! Cache 설정 신발보다 싸다",
category: :dev,
tags: ["개발", "Elixir", "Nebulex", "Cache"]
}

---

이 블로그는 웹에서 요청을 받았을 때 [코드 안에 markdown 파일로 저장되어 있는 글들](https://github.com/nallwhy/json_corp/tree/main/apps/json_corp/priv/posts)을 불러와서 보여준다.

아직은 글이 몇 개 안되어서 상관 없지만, 서버가 새로 배포되어 markdown 파일이 변경되기 전까지는 항상 같은 글 데이터를 불러와서 보여주기 때문에 cache 를 설정하는 것이 장기적으로 적절하다.

이번 글에서는 Elixir 에서 [`Nebulex`](https://github.com/cabol/nebulex) 로 cache 설정하는 것을 정리해보았다.

## Nebulex

`Nebulex` 는 caching 을 추상화해서 적은 코드로 새로운 caching solution 을 추가하거나 다른 caching solution 으로 변경할 수 있게 해주는 library 이다. Built-in caching solution 도 매우 좋아서 clustered multi-level cache 도 Redis 같은 외부 의존 없이 간단하게 구현 가능하고, Redis 등을 사용해서 cache 를 구현하고자 할 때도 별다른 이해 없이 쉽게 적용할 수 있다.

## Implementation

### Add `nebulex` to dependency

먼저 `nebulex` 를 dependency 에 추가한다. local adapter 나 partiAttribute 를 이용해 cache 를 설정하고 싶다면 `decorator`, Telemetry event([Elixir 에서 Telemetry 로 Ecto 의 Slow Query 로깅하기 참조](./20220827_logging_slow_queries_with_telemetry.md#telemetry)) 로 Nebulex stats 를 보려면 `telemetry` 도 추가해준다.

```elixir
defmodule MyApp.MixProject do
  ...

  defp deps do
    [
      ...
      {:nebulex, "~> 2.4"},
      {:shards, "~> 1.0"},     #=> When using :shards as backend
      {:decorator, "~> 1.4"},  #=> When using Caching Annotations
      {:telemetry, "~> 1.1"}   #=> When using the Telemetry events (Nebulex stats)
    ]
  end
end
```

`Nebulex` 는 여러가지 adapter 를 지원한다. 사용하고자 하는 adapter 를 선택하고, 그에 맞는 dependency 를 추가해줘야할 수도 있다. [참조](https://github.com/cabol/nebulex#usage). 이 글에서는 가장 간단한(그렇지만 대부분 경우 충분한) `Nebulex.Adapters.Local` 을 이용해서 구현할 것이다.

### Create a cache module

이제 cache 를 다룰 module 을 아래와 같이 만든다. `adapter` 부분에 원하는 Nebulex adapter 를 설정한다.

```elixir
defmodule MyApp.Cache do
  use Nebulex.Cache,
    otp_app: :my_app,
    adapter: Nebulex.Adapters.Local
end
```

### Config the cache module

adapter 에 대한 추가 설정을 하고자 하는 경우 `config.exs` 에 추가한다. adapter 별로 설정할 수 있는 option 들은 document 에서 확인할 수 있다. 이번에 사용할 [`Nebulex.Adapters.Local` document](https://hexdocs.pm/nebulex/Nebulex.Adapters.Local.html) 를 확인하고 설정해보자.

```elixir
config :my_app, MyApp.Cache,
  gc_interval: :timer.hours(12),
  allocated_memory: 2_000_000_000, # 2GiB
  backend: :shards
```

### Add the cache module to the child of Application

위에서 만든 cache module 을 Application supervisor 에 등록해서 application 시작 시 함께 시작되도록 한다.

```elixir
defmodule MyApp.Application do
  def start(_type, _args) do
    children = [
      MyApp.Cache,
      ...
    ]

    ...
  end
end
```

### Apply cache

`Nebulex` 로 cache 를 적용하는 방법은 두 가지이다.

#### decorator 사용

함수에 decorator 를 사용해서 cache 를 적용해보면 아래와 같다.

```elixir
defmodule MyApp.Blog do
  use Nebulex.Caching
  alias MyApp.Cache

  defmodule Post do
    defstruct [:slug, :title, :description]
  end

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {Post, slug}, match: &match/1, opts: [ttl: @ttl])
  def get_post(slug) do
    ...
  end

  @decorate cache_put(cache: Cache, key: {Post, slug}, match: &match/1, opts: [ttl: @ttl])
  def update_post(%Post{slug: slug} = post, attrs) do
    ...
  end

  @decorate cache_evict(cache: Cache, key: {Post, slug})
  def delete_post(%Post{slug: slug}) do
    ...
  end

  defp match({:ok, value}), do: {true, value}
  defp match(_), do: false
end
```

아래는 각 decorator 들에 대한 설명이다.

참고: https://hexdocs.pm/nebulex/Nebulex.Caching.html

#### `cacheable` decorator

cache key 에 해당하는 cache 가 없으면 함수를 실행한 후 cache 를 생성하고, 있으면 함수를 실행하지 않고 cache 를 반환한다.

- args
  - `cache`: cache module
  - `key` or `keys`: cache key. cache module 내에서 unique 한 identifier 가 된다.
  - `match`: 함수의 결과에 따라 cache 여부, 저장할 값을 결정한다. (optional)
  - `opts`: 기타 ttl 등의 옵션을 설정한다. (optional)

#### `cache_put` decorator

`cacheable` decorator 와는 다르게 항상 함수가 실행되고 cache key 에 해당하는 cache 를 생성/변경 한다.

- args
  - cacheable 과 동일

#### `cache_evict` decorator

cache key 에 해당하는 cache 를 evict 한다.

- args
  - `cache`: cache module
  - `key` or `keys`: cache key (optional)
  - `all_entries`: `true` 로 설정되면 cache module 의 모든 cache 를 evict 한다. (optional)

#### Nebulex 함수 직접 사용

이번에는 Nebulex 함수를 직접 사용해서 cache 를 적용해보았다.

```elixir
defmodule MyApp.Blog do
  alias MyApp.Cache

  defmodule Post do
    defstruct [:slug, :title, :description]
  end

  @ttl :timer.hours(1)

  def get_post(slug) do
    cache_key = {Post, slug}

    case Cache.has_key?(cache_key) do
      true ->
        Cache.get(cache_key)

      false ->
        with {:ok, %Post{} = post} <- do_get_post(slug) do
          Cache.put(cache_key, post, ttl: @ttl)

          {:ok, post}
        else
          {:error, reason} -> {:error, reason}
        end
    end
  end

  def update_post(%Post{slug: slug} = post, attrs) do
    cache_key = {Post, slug}

    with {:ok, %Post{} = updated_post} <- do_update_post(post, attrs) do
      Cache.put(cache_key, updated_post, ttl: @ttl)

      {:ok, updated_post}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @decorate cache_evict(cache: Cache, key: {Post, slug})
  def delete_post(%Post{slug: slug} = post) do
    cache_key = {Post, slug}

    with {:ok, %Post{} = deleted_post} <- do_delete_post(post) do
      Cache.delete(cache_key)

      {:ok, deleted_post}
    end
  end

  defp do_get_post(slug) do
    ...
  end

  defp do_update_post(post, attrs) do
    ...
  end

  defp do_delete_post(post) do
    ...
  end

  defp match({:ok, value}), do: {true, value}
  defp match(_), do: false
end
```

Nebulex 함수를 직접 사용해서 cache 를 적용하면 코드가 더 복잡해지지만 더 다양한 구현이 가능하다.

참고: https://hexdocs.pm/nebulex/getting-started.html

끝!
