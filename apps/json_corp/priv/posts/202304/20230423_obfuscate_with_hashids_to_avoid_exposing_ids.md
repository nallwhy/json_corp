%{
title: "Hashids 로 난독화하여 ID 노출하지 않기",
description: "아직도 URL 에 '/users/13' 같이 사용자 ID 가 노출되고 있다면",
category: "dev",
cover_url: "/images/blog/20230423_cover.png",
tags: ["개발", "Hashids", "난독화"]
}

---

웹 서비스를 사용하다 보면 URL 에 `/users/13` 같이 사용자 ID 가 노출되는 것을 본 적이 종종 있을 것이다.\
때로는 보안설정을 잘못하여 `/users/14` 같이 사용자 ID 를 변경하면 다른 사람의 정보가 노출되는 보안 이슈가 발생해 뉴스가 되기도 한다.

이번 글에서는 [`Hashids`](https://hashids.org/) 라는 library 를 이용해 ID 를 난독화 하여 공개하는 방법을 정리해보려고 한다.\
(대부분의 서비스는 사용자의 ID 가 어떤 방법으로든 노출될 필요가 없다.)

### 난독화(Obfuscation)란 무엇인가

**난독화**는 의도적으로 어떤 것을 읽기 힘들게 만드는 것을 의미한다.

예를 들어 `13` 이라는 사용자 ID 를 `"LkzPdy7aQrov"` 같이 난독화하면 이것을 읽고 원래 `13` 이라는 값을 알아내기 어렵다.

하지만 난독화가 '암호화' 는 아닌데, 암호화는 'brute-force attack' 등의 공격에도 매우 안전해야 하는 반면 난독화는 반드시 그 정도 수준의 보안을 보장하지는 않기 때문이다.

### Hashids 란 무엇인가

`Hashids` 는 난독화 오픈소스이다. 수십 개의 언어로 동일하게 구현되어있을 정도로 보편적으로 사용되고 있다.

<figure>
  <img src="/images/blog/20230423_hashids_homepage.png" alt="Hashids homepage">
  <figcaption>본인이 사용하는 언어로 구현되어있지 않다면 직접 구현해보는 것도?</figcaption>
</figure>

제공하는 기능은 아래와 같다.

- non-negative integers 를 짧은 string 으로 encoding 해주고, 역으로 decoding 할 수 있다.
- salt 를 이용해서 encoding 하기 때문에, salt 를 모르는 경우 decoding 하기 어렵다.
- 최소 길이를 설정할 수 있다. (encoding 결과는 달라지지만 decoding 은 가능하다. 즉, 나중에 변경할 수 있다.)
- Custom string 을 이용하여 encoding 할 수 있다.
- 순증하는 입력에도 결과를 추측하기 어렵다.

아래는 Elixir 로 구현된 `Hashids` 의 사용 예이다.

```elixir
hashids = Hashids.new(salt: "this is my salt")
id = Hashids.encode(hashids, [1, 2, 3])  # "laHquq"
numbers = Hashids.decode!(hashids, id)   # [1, 2, 3]
```

아래는 Custom string 과 최소 길이를 설정하여 사용하는 예이다.

```elixir
custom_string = "abcdefgАБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФЦЧШЩЬЮЯ"
hashids = Hashids.new(salt: "ЦжЧєДОЄ8ук", alphabet: custom_string, min_len: 16)
id = Hashids.encode(hashids, [1, 2, 3])  # "УКОРЦФЮМcЄaДФЯЮЇ"
numbers = Hashids.decode!(hashids, id)   # [1, 2, 3]
```

### 어떨 때 Hashids 를 사용하는가

어떤 정보를 노출하고 싶지는 않지만 완전히 숨기기는 힘들 때 `Hashids` 를 사용하면 좋다.

예를 들어 내가 어떤 서비스에 새로 가입한 후에 '마이 페이지' URL 이 `/users/13` 와 같이 되어있다면, 내가 이 서비스의 13번째 사용자임을 알 수 있다.\
`/users/13` 을 `/users/jDdxaGv2` 와 같이 난독화하면 사용자의 ID 를 알아내기 어렵다.\
서비스의 규모가 밝혀지고 싶지 않을 때 난독화를 적용할 수 있다.

그리고 `/products/127` 로 접근이 가능하다면 `/products/128` 로 임의 접근도 가능할 수 있다는 힌트를 주는데, 이는 보안 문제나 웹 스크래핑의 가능성을 더 높일 수도 있다.\
이러한 문제의 가능성을 줄이는데 난독화를 적용할 수 있다.

난독화 대신 UUID 같은 것을 사용하는 방법도 있지만, UUID 는 deterministic 하게 계산되는 값이 아니므로 어딘 가에 그 값이 반드시 저장되어 있어야 하며, 그러면 매번 그 저장된 값을 불러와야만 원래의 값과 매핑을 할 수 있다.\
따라서 구현이 더 귀찮다.
(더불어 URL 이 너무 길어져서 보기 싫어지며, 자연스럽게 공유되었을 때도 거부감이 드는 URL 이 된다.)

또 얼마 전에 난독화를 사용하면 좋은 케이스가 공유된 것이 있었다.

<figure>
  <img src="/images/blog/20230423_obfuscation_example.png" alt="Obfuscation example">
  <figcaption>겹치지 않는 referral code 를 만드는 좋은 방법은?</figcaption>
</figure>

저 글의 작성자 분은 겹치지 않는 임의 생성 때문에 UUID 를 기반으로 고려하셨지만, UUID 는 너무 길어서 그대로 적절하지 못해 자르다보니 다시 collision 을 고민해야하는 상황에 놓였다.

이럴 때 `Hashids` 를 사용하면 1억 명의 사용자라도 7글자의 string 으로 referral code 를 생성해줄 수 있다.

### 어떨 때 Hashids 를 사용하지 않는가

- negative integer 에 사용할 수 없다.
  - 원한다면 음수의 경우는 `[1, -<negative integer>]` 같이 표현한다든지 해서 사용할 방법은 있다.
- 보안을 위해 사용하지 않는다.
  - 암호화와는 다르게 여러가지 공격에 상대적으로 취약하다.
  - 하지만 그렇다고 쉽게 뚫을 수 있는 것도 아니기는 하다.
  - 보안은 뚫었을 때 얻을 수 있는 것 대비 뚫는 비용이 큰가가 중요하다.
    - 보안이 매우 중요하지는 않은 부분에 사용하면 대체로 Hashids 도 이를 만족하기는 한다.

### 유사한 대안들

- Base64 encode: 값을 숨기지 않고 문자로 바꾸고 싶기만 한 것이라면 적절한 선택이다.
- UUID, Nano ID: 충돌 가능성이 있어도 괜찮고 decoding 이 되지 않아도 된다면 적절한 선택이다.
- Optimus, Feistel cipher: '숫자 -> 문자' 가 아니라 '숫자 -> 숫자' 로의 매핑을 원한다면 적절한 선택이다.

---

참고로 `Hashids` 는 hash 와 아무 관련이 없다.

> ### why "hashids"?
>
> Originally the project referred to generated ids as hashes, and obviously the name hashids has the word hash in it. Technically, these generated ids cannot be called hashes since a cryptographic hash has one-way mapping (cannot be decrypted).
>
> However, when people search for a solution, like a "youtube hash" or "bitly short id", they usually don't really care of the technical details. So hashids stuck as a term — an algorithm to obfuscate numbers.

https://hashids.org/
