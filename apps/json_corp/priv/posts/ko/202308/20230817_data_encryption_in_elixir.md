%{
title: "B2B SaaS 의 보안을 높여주는 데이터 암호화 in Elixir",
description: "Elixir 로 B2B SaaS 를 만드는 여정 - (2)",
category: "dev",
cover_url: "/images/blog/20230817_cover.jpg",
tags: ["개발", "암호화", "Encryption", "B2B", "SaaS", "Cloak", "Elixir"]
}

---

Elixir 로 B2B SaaS [reflow](https://reflow.work) 를 만들면서 경험한 내용 시리즈입니다.

1. [B2B SaaS 의 보안을 높여주는 Multi-Tenancy in Elixir](./multi_tenency_in_elixir)
2. **B2B SaaS 의 보안을 높여주는 데이터 암호화 in Elixir**
3. B2B SaaS 의 보안을 높여주는 Redaction in Elixir
4. Job Scheduling 예정
5. Feature Flag 예정
6. Obfuscation 예정

---

B2B SaaS 는 대체로 고객의 민감한 정보를 다루기 때문에 **암호화**의 필요성을 더 말할 필요는 없을 것 같습니다.

이번 글에서는 암호화가 무엇이고, Elixir 에서 암호화를 어떻게 구현할 수 있는지 알아봅니다.

## 암호화란 무엇인가

**암호화**는 어떤 정보를 encoding 하여, 나중에 권한을 가지고 있는 주체만 이를 복호화해서 정보를 볼 수 있도록 하는 것을 말합니다.

> In cryptography, encryption is the process of encoding information. This process converts the original representation of the information, known as plaintext, into an alternative form known as ciphertext. Ideally, only authorized parties can decipher a ciphertext back to plaintext and access the original information.
>
> \- [Wikipedia - Encryption](https://en.wikipedia.org/wiki/Encryption)

저장되거나 전송되는 고객의 정보가 절대 탈취당하지 않으면 좋겠지만, 불의의 사고는 항상 일어나기 마련입니다. 암호화는 누군가 저장되거나 전송되는 정보를 탈취하더라도, 그 정보를 해석할 수 없게 하여 최종적으로 고객 정보의 유출을 막기위해 사용됩니다.

예를 들어 데이터베이스에 저장되어있던 데이터들이 탈취당한다고 하더라도, 데이터가 암호화 되어있다면 암호화 키도 같이 탈취당한 것이 아닌 이상 데이터 유출 걱정은 적습니다.

### 간단한 암호화 방법의 예

간단한 암호화 방법을 한 번 살펴볼까요?

`Caesar cipher` 는 고대 로마의 황제 시저가 사용했던 암호화 방법으로, 암호화 하고자 하는 글의 알파벳을 일정 차이만큼 다른 알파벳으로 바꾸는 암호화 방법입니다.

예를 들어, A -> C, B -> D, C -> E 이렇게 2글자 차이만큼 다른 알파벳으로 바꿔서 적는 것이죠.\
그러면 `APPLE` -> `CRRNG` 와 같이 암호화되어 원래 내용을 쉽게 알아볼 수 없게 됩니다.

<figure>
  <img src="/images/blog/20230817_caesar_cipher.jpg" alt="Caesar cipher">
  <figcaption>Caesar cipher 는 이런 기계를 이용하여 쉽게 암호화/복호화 할 수 있습니다.</figcaption>
</figure>

이러한 암호화를 공격하는 방법에는 대표적인 몇 가지 방법들이 있습니다.

#### 암호화 키 탈취

암호화는 복호화를 할 수 있어야 하기에, 암호화된 정보를 복호화 할 수 있는 키가 존재합니다. 따라서 이 키를 탈취하면 쉽게 암호화된 정보를 복호화 할 수 있습니다. 위의 예시에서 `CRRNG` 가 **2글자** 차이로 암호화 되었다는 사실을 알면 `APPLE` 로의 복호화는 매우 쉽습니다.

#### 통계적인 특성으로 유추

Caesar cipher 로 긴 영어 문장을 암호화했다고 가정합시다. 우리는 영어에서 `e` 가 가장 빈도가 높은 알파벳임을 알고 있습니다. 따라서 암호화된 정보에서 빈도가 높은 알파벳들이 `e` 라는 가정하에 복호화를 시도하면 이를 쉽게 성공할 수 있습니다.

#### 반복적인 내용으로 유추

Caesar cipher 로 두 사람간의 편지를 암호화했다고 가정합시다. 오가는 편지를 여러 개 모아서 보면, 편지가 시작할 때 자주 보이는 패턴이 `Hi` 같이 자주 사용되는 인사가 아닐까 생각해볼 수 있습니다. 이런 방식으로 암호화된 정보를 많이 모아서 규칙을 찾아 암호화를 공격할 수 있습니다.

#### 무차별 대입 (Brute Force)

Caesar cipher 는 암호화 할 수 있는 방법이 알파벳 개수인 26가지 밖에 되지 않습니다. 따라서 26가지 방법을 다 시도하면 복호화를 할 수 있습니다.

이 밖에도 많은 암호화 공격 방법이 있습니다.

현대 암호화 방법은 키의 값이 매우 크다든지, 같은 정보를 반복적으로 암호화 해도 다른 결과로 암호화 된다든지, 주기적으로 키를 rotation 할 수 있다든지 등의 방법으로 여러가지 공격에 최대한 대응할 수 있도록 설계되어있습니다.

## Elixir 로 데이터 암호화 구현하기

[Cloak](https://github.com/danielberkompas/cloak) 은 Elixir 에서 데이터를 암호화를 도와주는 라이브러리로, 아래와 같은 특징을 가지고 있습니다.

- `AES-GCM`, `AES-CTR` 두 가지 암호화 방법을 자체적으로 지원하며, 원하면 직접 암호화 방법을 구현하여 사용할 수도 있습니다.
- Random IV(Initialization Vector) 기능을 제공하기 때문에 같은 정보를 반복적으로 암호화 해도 매번 다른 결과로 암호화 되어 보안적으로 실수하지 않게 해줍니다.
- 암호화 결과에 태그 정보가 있어서, 나중에 암호화 키를 rotation 하기 용이합니다.
- [Cloak.Ecto](https://github.com/danielberkompas/cloak_ecto) 도 함께 제공하여, 데이터베이스 암호화에 쉽게 사용할 수 있습니다. ([Ecto](https://github.com/elixir-ecto/ecto) 는 Elixir 에서 데이터베이스 관련 작업을 도와주는 라이브러리입니다.)

`Cloak` 으로 데이터베이스에 저장하기/불러오기 시 자동으로 암호화/복호화 되도록 하는 작업해보겠습니다.

### Cloak 설정하기

먼저 `Cloak`, `Cloak.Ecto` 를 dependency 에 추가해줍니다.

```elixir
defmodule MyApp.MixProject do
  use Mix.Project

  ...

  defp deps do
    [
      ...
      {:cloak, "~> 1.1"},
      {:cloak_ecto, "~> 1.2"}
    ]
  end
end
```

다음으로 암호화/복호화를 담당하는 Vault module 을 만들고, config 를 추가해줍니다. 여기서는 암호화 방법으로 `AES-GCM` 을 이용했습니다.

```elixir
defmodule MyApp.Vault do
  use Cloak.Vault, otp_app: :my_app
end
```

```elixir
import Config

...

config :my_app, MyApp.Valut,
  ciphers: [
    default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: Base.decode64!("your-key-here")}
  ]
```

cipher key 는 IEx(Interactive Shell) 등에서 아래와 같은 방법으로 쉽게 만들 수 있습니다.

```elixir
iex> 32 |> :crypto.strong_rand_bytes() |> Base.encode64()
"HXCdm5z61eNgUpnXObJRv94k3JnKSrnfwppyb60nz6w="
```

마지막으로 Application supervison tree 에 추가해주면 `Cloak` 을 사용할 준비는 끝납니다.

```elixir
defmodule MyApp.Application do
  use Application

  ...

  def start(_type, _args) do
    children = [
      ...,
      MyApp.Vault
    ]
  end
end
```

### Cloak 으로 암호화/복호화 하기

위에서 만든 `MyApp.Vault` module 로 아래와 같이 쉽게 암호화/복호화를 할 수 있습니다.

```elixir
iex> {:ok, ciphertext} = MyApp.Vault.encrypt("plaintext")
{:ok, <<1, 10, 65, 69, 83, 46, 71, 67, 77, 46, 86, 49, 93, 140, 255, 234,
1, 195, 125, 112, 121, 186, 169, 185, 129, 122, 237, 161, 160, 24, 166,
48, 224, 230, 53, 194, 251, 175, 215, 10, 186, 130, 61, 230, 176, 102,
213, 209, ...>>}

iex> MyApp.Vault.decrypt(ciphertext)
{:ok, "plaintext"}
```

### Cloak.Ecto 로 데이터베이스 저장하기/불러오기 시에 자동으로 암호화/복호화 하기

먼저 각 Vault, 각 type 별로 local Ecto type 을 선언해줘야 합니다. 여기서는 `MyApp.Vault` 로 `Binary`(String) 을 저장하기 위한 local Ecto type 을 선언해보겠습니다.

```elixir
defmodule MyApp.Encrypted.Binary do
  use Cloak.Ecto.Binary, vault: MyApp.Vault
end
```

다음으로 새로 `User` 를 만들면서 email 을 암호화 하고자 하는 시나리오로 구현해보겠습니다.

`users` table 을 만들 때 `encrypted_email` column 을 `binary` type 으로 설정해줍니다. (`email` 로 만들어도 되지만 column 명이 명확한 것을 좋아합니다.)

```elixir
defmodule MyApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      field :encrypted_email, :binary, null: false
    end
  end
end
```

```elixir
defmodule MyApp.Accounts.User do
  use Ecto.Schema

  schema "users" do
    field :email, MyApp.Encrypted.Binary, source: :encrypted_email
  end
end
```

이렇게 field type 만 설정해주면 데이터를 데이터베이스에 저장하고 불러올 때 자동으로 암호화/복호화가 되어 어플리케이션에서는 신경쓸 것이 없습니다.

```elixir
MyApp.Repo.get(MyApp.Accounts.User, 1)
# => %Accounts.User{email: "test@example.com"}
```

---

이렇게 Elixir 에서는 적은 코드의 수정으로 전체 어플리케이션에 데이터 암호화를 적용할 수 있습니다.

이는 더 빠르고 안전한 B2B SaaS 개발로 이어집니다.

다음 글에서는 'B2B SaaS 의 보안을 높여주는 Redaction in Elixir' 에 대해 얘기해보도록 하겠습니다.

감사합니다!

---

References:

- [Why Your SaaS App Needs Better Encryption](https://ironcorelabs.com/blog/2021/why-your-saas-needs-better-encryption/)
