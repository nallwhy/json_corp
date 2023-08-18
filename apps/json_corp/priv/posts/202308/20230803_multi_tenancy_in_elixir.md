%{
title: "B2B SaaS 의 보안을 높여주는 Multi-Tenancy in Elixir",
description: "Elixir 로 B2B SaaS 를 만드는 여정 - (1)",
category: "dev",
cover_url: "/images/blog/20230803_multi_tenancy.png",
tags: ["개발", "Multi-Tenancy", "B2B", "SaaS", "Ecto", "Elixir"],
aliases: ["multi_tenency_in_elixir"]
}

---

Elixir 로 B2B SaaS [reflow](https://reflow.work) 를 만들면서 경험한 내용 시리즈입니다.

1. **B2B SaaS 의 보안을 높여주는 Multi-Tenancy in Elixir**
2. [B2B SaaS 의 보안을 높여주는 암호화 in Elixir](./data_encryption_in_elixir)
3. Job Scheduling 예정
4. Feature Flag 예정
5. Obfuscation 예정

---

**'Multi-Tenancy'** 는 B2B SaaS 개발에서 떼어낼 수 없는 키워드입니다.

> Multitenancy is a requirement for a SaaS vendor to be successful.
>
> \- Marc Benioff, Salesforce 공동 창업자

이번 글에서는 Multi-Tenancy 가 무엇이고 왜 B2B SaaS 에서 중요한지, 그리고 Elixir 에서 Multi-Tenancy 를 어떻게 쉽게 구현할 수 있는지 알아봅니다.

## Multi-Tenancy 란 무엇인가

**Multi-Tenancy** 는 하나의 어플리케이션에서 여러 고객에게 서비스를 제공하는 소프트웨어 아키텍처를 이야기합니다.

> The term "software multi tenancy" refers to a software architecture in which a single instance of the software runs on a server and serves multiple tenants.
>
> \- [Wikipedia - Multitenancy](https://en.wikipedia.org/wiki/Multitenancy)

감이 안오니 반대 개념인 **Single-Tenancy** 를 알아보겠습니다.

Single-Tenancy 는 고객마다 완전히 분리된 별도의 어플리케이션을 제공합니다.\
이 경우 완벽한 데이터 분리, 고객마다 별도의 어플리케이션 제공, 비교적 낮은 복잡도의 개발 등의 이점이 있습니다.

<figure>
  <img src="/images/blog/20230803_single_tenancy.png" alt="Single-Tenancy">
</figure>

그렇다면 **Multi-Tenancy** 는 하나의 어플리케이션으로 여러 고객들에게 서비스를 제공하는 모습임을 떠올릴 수 있습니다.

<figure>
  <img src="/images/blog/20230803_multi_tenancy.png" alt="Multi-Tenancy">
</figure>

이 때 꼭 모든 인프라가 모든 고객과 공유될 필요는 없습니다. 서버는 공유하고 데이터베이스는 분리하는 등 일부 리소스만 공유되더라도 개념상으로 Multi-Tenancy 라고 봅니다.

### Multi-Tenancy 의 필요성과 리스크

그러면 왜 B2B SaaS 에서 Multi-Tenancy 를 중요하다고 얘기하는 것일까요?

1. 인프라 비용 절감: 고객 당 비용이 줄어들면 더 높은 수익을 발생시킬 수 있습니다.
2. 스케일 관리 용이: 새로운 고객마다 별도의 인프라를 구성할 필요가 없으므로 상황에 따라 유연하게 스케일을 조정할 수 있습니다.
3. 유지 보수 용이: 고객 별로 어플리케이션을 관리하고 업그레이드 하는 것보다 효율적으로 시스템 유지보수를 할 수 있습니다.
4. 데이터 관리와 분석 용이: 전체 고객의 데이터를 한 번에 접근할 수 있어 데이터 관리와 분석이 고객별로 분리된 인프라에서보다 더 쉽습니다.

반면 Multi-Tenancy 를 적용하면 관리해야할 리스크들도 있습니다.

1. 보안 위험 (특히, 데이터 유출): 여러 고객이 인프라를 공유하기 때문에 고객 간 데이터 분리가 제대로 이루어지 않는다면 데이터 유출 사고로 이어질 수 있습니다.
2. Noisy Neighbour 문제: 리소스를 많이 사용하는 소수의 고객으로 인해 다른 고객들의 서비스 성능이 저하될 수 있습니다.
3. 더 복잡한 어플리케이션 개발: Multi-Tenancy 를 구현하기 위해 어플리케이션 개발이 더 복잡해질 수밖에 없습니다.
4. 더 낮은 고객 별 유연성: 어플리케이션을 여러 고객이 공유하기 때문에 개별 고객의 요구사항을 충족하기 더 어렵습니다.

### 원래 다 Multi-Tenancy 아니야?

위의 Multi-Tenancy 정의를 보고 나면 이런 생각이 들 수 있습니다.

예를 들면 카카오톡 같은 B2C 서비스는 여러명의 고객이 같은 어플리케이션을 공유해서 사용하므로 Multi-Tenancy 로 생각될 수 있습니다.

이 부분에 대해서 정확한 답을 찾지는 못했지만, 두 가지 가설이 있습니다.

1. Multi-Tenancy 가 SaaS 쪽에서만 사용되는 개념이어서 B2C 서비스를 굳이 Multi-Tenancy 라고 말하지 않는다.
2. Multi-Tenancy 는 여러 고객이 어플리케이션을 공유하면서도 동시에 각 고객의 데이터와 기능이 분리되어 있는 구조를 의미하는데, B2C 서비스에서는 이를 SaaS 만큼 중요하게 고려하지는 않으므로 Multi-Tenancy 라고 얘기하기 어렵다.

혹시 답을 아시는 분은 저에게 알려주시길!

## Elixir 로 Multi-Tenancy 구현하기

데이터베이스 레벨에서 Multi-Tenancy 는 아래와 같은 세 레벨들로 구현될 수 있습니다.

- 고객 별 데이터베이스
- 고객 별 분리된 스키마
- 고객 간 공유되는 스키마

일반적으로 위쪽의 방법일 수록 더 보안적으로 안전하다고 여겨지지만, 더 구현과 관리가 어렵습니다.

[Ecto](https://github.com/elixir-ecto/ecto) 는 Elixir 에서 데이터베이스 쿼리와 데이터 매핑을 도와주는 라이브러리인데, Ecto 에서는 위의 세 레벨 Multi-Tenancy 구현에 대해 각각 아래와 같은 방법을 제공합니다.

- 고객 별 데이터베이스: [Dynamic Repositories](https://hexdocs.pm/ecto/replicas-and-dynamic-repositories.html#dynamic-repositories)
- 고객 별 분리된 스키마: [Multi tenancy with query prefixes](https://hexdocs.pm/ecto/multi-tenancy-with-query-prefixes.html)
- 고객 간 공유되는 스키마: [Multi tenancy with foreign keys](https://hexdocs.pm/ecto/multi-tenancy-with-foreign-keys.html)

이를 통해 Ecto 는 위에 설명한 Multi-Tenancy 리스크 중 두 가지를 해결합니다.

1. 보안 위험 (특히, 데이터 유출): 확실한 Multi-Tenancy 구현을 제공함으로써, 데이터 유출 위험을 줄입니다.
2. 더 복잡한 어플리케이션 개발: 매우 쉬운 Multi-Tenancy 구현을 제공함으로써, Multi-Tenancy 어플리케이션 개발을 간단히 할 수 있게 합니다.

이번 글에서는 **Multi tenancy with foreign keys** 구현을 알아봅니다.

### Multi-Tenancy with Foreign Keys

고객 간 데이터베이스 스키마를 공유하면서도 foreign key 를 이용해 데이터를 분리할 수 있습니다.\
Ecto 는 이를 쉽게 구현할 수 있도록 기능을 제공합니다.

아래에서 `prepare_query/3` callback, Process dictionary, `default_options/1` callback 을 이용하여 Multi-Tenancy 를 구현해보겠습니다.

#### `prepare_query/3` callback

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo, otp_app: :my_app
  require Ecto.Query

  @impl true
  def prepare_query(_operation, query, opts) do
    cond do
      # opts[:skip_org_id] || opts[:schema_migration] ->
      #   {query, opts}

      org_id = opts[:org_id] ->
        {Ecto.Query.where(query, org_id: ^org_id), opts}

      true ->
        raise "expected org_id or skip_org_id to be set"
    end
  end
end

# Call with org_id option
MyApp.Repo.all Post, org_id: 13
```

Ecto 는 모든 query 전에 실행되는 [`prepare_query/3`](https://hexdocs.pm/ecto/3.10.3/Ecto.Repo.html#c:prepare_query/3) callback 을 지원합니다.

위 코드는 모든 query 에 `org_id` option 값을 이용한 `where` 조건을 적용하고, 만약 `org_id` 이 설정되지 않았다면 에러를 발생시킵니다.

이를 통해 `org_id` 를 강제하여 여러 고객의 데이터가 한 번에 쿼리되지 않도록 강제할 수 있습니다.

#### Process dictionary

```elixir
defmodule MyApp.Tenant do
  @tenant_key {__MODULE__, :org_id}

  def put_org_id(org_id) do
    Process.put(@tenant_key, org_id)
  end

  def get_org_id() do
    Process.get(@tenant_key)
  end
end

# Put org_id to process
MyApp.Tenant.put_org_id(13)

# Call with org_id from process
MyApp.Repo.all Post, org_id: MyApp.Tenant.get_org_id()
```

Elixir 는 Beam(Erlang VM) 위에서 수 많은 process 를 띄우는 [Actor Model](https://en.wikipedia.org/wiki/Actor_model) 을 기반으로 동작합니다.

이 때 각 process 는 memory, message box 등 자신만의 리소스를 가지는데 그 중 dictionary 도 가지고 있어서 여기에 key-value 쌍을 저장할 수 있습니다. 이는 코드가 실행되는 동안 유지되는 context 로 사용될 수 있습니다.

<figure>
  <img src="/images/blog/20230803_erlang_vm_process.png" alt="Erlang VM Process">
</figure>

위 코드는 쿼리할 때 process 에 저장한 `org_id` 를 가져와서 사용하는 방식을 구현하였습니다.

#### `default_options/1` callback

```elixir
defmodule MyApp.Repo do
  ...

  @impl true
  def default_options(_operation) do
    [org_id: MyApp.Tenant.get_org_id()]
  end
end

# Put org_id to process
MyApp.Tenant.put_org_id(13)

# Call with org_id from process automatically
MyApp.Repo.all Post
```

Ecto 는 모든 query 에 default options 를 설정하는 [`default_options/1`](https://hexdocs.pm/ecto/3.10.3/Ecto.Repo.html#c:default_options/1) callback 을 지원합니다.

위 코드는 더 이상 `MyApp.Tenant.get_org_id()` 을 호출하여 직접 `org_id` option 을 설정하지 않더라도 `default_options/1` callback 을 통해 자동으로 `org_id` 가 설정되도록 합니다.

이제 query 가 실행되기 전 어디서든 `MyApp.Tenant.put_org_id(org_id)` 를 해준다면, 이후 실행되는 모든 query 에 해당 `org_id` 이 적용되어 동작합니다.

#### Hook 에서 `org_id` 설정하기

[Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) 를 사용한다면, Hook 을 이용해 authentication 을 하면서 `org_id` 가 설정되도록 할 수 있습니다.

```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  ...

  scope "/", MyAppWeb do
    pipe_through [:browser, :auth]

    # app live_session 안에 있는 모든 경로에 `MyAppWeb.AuthHook` 을 설정합니다.
    live_session :app, on_mount: [MyAppWeb.AuthHook] do
      live "/posts", PostLive.Index
    end
  end
end

defmodule MyAppWeb.AuthHook do
  def on_mount(:default, _params, %{"org_id" => org_id}, socket) do
    ... # Authentication

    # Put org_id to process
    MyApp.Tenant.put_org_id(org_id)

    {:cont, socket}
  end
end
```

이렇게 하면 모든 요청에서 `org_id` 가 설정되어 다른 고객의 데이터가 잘못 유출될 여지가 사라집니다.

여기까지 총 50줄이 안되는 코드의 수정만으로 전체 어플리케이션의 다른 수정 일절 없이 Multi-Tenancy 를 적용했습니다.

### 조심해야할 점들

- 하나의 Repo 만 사용하기: Multi-Tenancy 를 적용한 Repo 와 그렇지 않은 Repo 를 별도로 사용하려는 유혹이 들 수 있습니다. 하지만 그런 경우 transcation 처리가 어려워지고, transaction 을 이용하는 sandbox testing 또한 어려워집니다.
- Tenancy 를 넘나드는 코드는 모듈 분리하기: 하나의 모듈에서 `skip_org_id` option 을 이용하는 코드와 그렇지 않은 코드를 혼용해서 쓰면 실수할 여지가 생깁니다. 코드를 완전히 분리해서 하나의 모듈에서는 Tenancy 정책이 일관되게 적용되도록 하는 것을 추천합니다.
- 새 process 를 사용할 때 context 전달하기: concurrency 를 위해 process 를 새로 띄우서 사용하는 경우 process dictionary 는 복사되지 않습니다. 새 process 에도 context 가 유지되도록 복사하는 것을 잊지 말아야 합니다.

---

이렇게 Elixir 에서는 적은 코드의 수정으로 전체 어플리케이션에 확실하고 간단한 Multi-Tenancy 구현을 적용할 수 있습니다.

이는 더 빠르고 안전한 B2B SaaS 개발로 이어집니다.

다음 글에서는 'B2B SaaS 의 보안을 높여주는 데이터 암호화 in Elixir' 에 대해 얘기해보도록 하겠습니다.

감사합니다!

---

References:

- [What Is Multitenancy: Definition, Importance, and Applications](https://www.simplilearn.com/what-is-multitenancy-article#benefits_of_multitenancy_architecture)
- [Tenancy models for a multitenant solution](https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/considerations/tenancy-models)
- [Re-defining multi-tenancy](https://docs.aws.amazon.com/whitepapers/latest/saas-architecture-fundamentals/re-defining-multi-tenancy.html)
- [B2B SaaS 는 일반적인 B2C 비즈니스와 무엇이 다를까요?](https://maily.so/saascenter/posts/2982fba1)
- [What's Under the Hood of SaaS Companies](https://shomik.substack.com/p/whats-under-the-hood-of-saas-companies?s=r)
- [Your Guide To Schema-based, Multi-Tenant Systems and PostgreSQL Implementation](https://hackernoon.com/your-guide-to-schema-based-multi-tenant-systems-and-postgresql-implementation-gm433589)
