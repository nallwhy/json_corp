%{
title: "Elixir 에서 Telemetry 로 Ecto 의 Slow Query 로깅하기",
description: "앗! Slow Query 로깅 신발보다 싸다",
category: "dev"
}

---

Slow query 는 백엔드에 병목을 만드는 요인 중 하나이다.

Slow query 로 인해 DB 에 리소스가 부족한 문제가 발생했을 때 이를 제대로 처리하지 않고 DB 성능을 늘리는 식으로 해결하려 하는 경우들이 있다. 하지만 정상적인 query 와 slow query 의 차이는 x100 이상은 가뿐히 나기 때문에, DB 성능을 몇 배 올려서 당장 해결이 되었다고 해도 곧 다시 문제가 발생한다.

AWS RDS 를 쓴다면 slow query 를 찾기위해 [Performance Insight](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.html) 같은 것을 사용해볼 수도 있지만, query 가 긴 경우 query 전체를 보기가 어렵거나 불가능한 경우도 있다.[1]

이 문제를 해결하기 위해, Elixir 에서 [Telemetry](https://github.com/beam-telemetry/telemetry) 를 사용하여 간단하게 slow query 를 로깅하는 방법을 알아보자.

## Telemetry

어느 순간부터 Elixir 에서 주로 사용되는 대부분의 library(ex. [`Phoenix`](https://github.com/phoenixframework/phoenix), [`Ecto`](https://github.com/elixir-ecto/ecto))에 Telemetry 라는 키워드가 보이기 시작했다.

`Telemetry` 는 dynamic 하게 event 에 handler 를 등록할 수 있게 해주는 library 이다. 주로 metric, instrumentation 을 위해 사용된다.[2]

내부적으로는 [`ETS`](https://www.erlang.org/doc/man/ets.html) 에 event 와 handler 를 연결해 등록시켜놓고, event 가 발생하면 해당 event 의 handler 들을 호출해주는 방식으로 동작한다.[3]

이런 구현 방식 덕분에, library 들이 내부에서 event 를 발생하도록 해놓기만 하면 사용자가 원하는 방식으로 handling 을 할 수 있다.

`Ecto` 도 여러 Telemetry event 를 제공하고 이 중에 [각 query 마다 해당 query 의 metric 을 얻을 수 있는 event 가 존재](https://hexdocs.pm/ecto/Ecto.Repo.html#module-adapter-specific-events)하므로, slow query 를 쉽게 로깅할 수 있다. (물론 로깅이 아닌 다른 것들도 할 수 있다)

## Implementation

`telemetry` 가 dependency 에 추가되지 않았다면 추가한다.

```elixir
def deps do
  [
    ...
    {:telemetry, "~> 1.1"}
  ]
end
```

Telemetry event 를 listening 할 함수를 생성한다. Telemetry event 이름은 atom list 로 이루어지는데, Ecto Adapter-specific event 의 event 이름은 `MyApp.Repo` 의 경우 `[:my_app, :repo] ++ [:query]` 와 같이 repo module 이름의 snake-case list 꼴로 정해진다. 원하는 경우 Telemetry event 이름을 repo 의 config 에 `:telemetry_prefix` 로 직접 설정할 수도 있다.

```elixir
defmodule MyApp.Telemetry do
  def handle_event([:my_app, :repo, :query], _measurements, _metadata, _config) do
    # TODO
    IO.inspect("telemetry event is triggered")
  end
end
```

`Application.start/2` callback 안에서 [`:telemetry.attach/4`](https://hexdocs.pm/telemetry/telemetry.html#attach/4) 로 해당 함수를 attach 한다. 첫번째 인자인 `handler_id` 는 unique 해야 한다.

```elixir
defmodule MyApp.Application do
  def start(_type, _args) do
    ...
    :ok = :telemetry.attach("slow-query", [:my_app, :repo, :query], &MyApp.Telemetry.handle_event/4, %{})
    ...
  end
end
```

이제 Ecto 가 query 를 실행하도록 해보면, 아까 만들었던 event handler 인 `MyApp.Telemetry.handle_event/4` 가 호출되어 console 에 `"telemetry event is triggered"` 가 찍히는 것을 볼 수 있다.

이어서 `MyApp.Telemetry.handle_event/4` 함수가 slow query 의 경우 로깅하도록 구현한다. 아래 구현에서는 최대한 Ecto 에서 제공하는 query debug 로깅과 동일한 모습을 보이도록 했다.

```elixir
defmodule MyApp.Telemetry do
  @slow_query_ms 1000
  def handle_event([:my_app, :repo, :query], measurements, metadata, _config) do
    [total_time_ms, queue_time_ms, query_time_ms] =
      [:total_time, :queue_time, :query_time]
      |> Enum.map(&to_ms(measurements[&1]))

    source = metadata[:source]
    query = metadata[:query]
    params = metadata[:params]

    if total_time_ms > @slow_query_ms do
      Logger.warn("""
      SLOW QUERY source: #{inspect(source)} db=#{query_time_ms}ms queue=#{queue_time_ms}ms
      #{query} #{inspect(params)}
      """)
    end
  end

  defp to_ms(measurement) when not is_nil(measurement) do
    System.convert_time_unit(measurement, :native, :millisecond)
  end

  defp to_ms(nil), do: 0
end
```

간혹 `queue_time` 등이 nil 인 경우가 있어서 `to_ms/1` 가 `nil` 을 따로 처리하도록 구현했다.

`@slow_query_ms` 를 `0` 같이 낮은 값으로 하고 아까와 같이 Ecto 가 query 를 실행하도록 해보면 로깅이 잘 되는 것을 확인해 볼 수 있다.

```
00:33:24.193 [warning] SLOW QUERY source: "users" db=5ms queue=0ms
SELECT u0."id", u0."email" FROM "users" AS u0 []
```

끝!

[1]: [Accessing more SQL text in the Performance Insights dashboard](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PerfInsights.UsingDashboard.SQLTextSize.html)\
[2]: [Telemetry Document](https://hexdocs.pm/telemetry/readme.html)\
[3]: [Phoenix Document - Telmetry - Overview](https://hexdocs.pm/phoenix/telemetry.html#overview)
