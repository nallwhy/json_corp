%{
title: "Phoenix 가 가장 사랑받는 Web framework 로 선정되었습니다",
description: "Stack Overflow Developer Survey 2023 속의 Elixir, Phoenix",
category: :dev,
cover_url: "/images/blog/20230624_cover.png",
tags: ["개발", "Elixir", "Phoenix", "Stack Overflow"]
}

---

얼마전 [Stack Overflow](https://stackoverflow.com/) 에서 매년 진행하는 [**Stack Overflow Developer Survey 2023**](https://survey.stackoverflow.co/2023) 결과가 발표되었습니다.

2022년 7만여 명의 개발자가 참여했던 **Stack Overflow Developer Survey** 는, 2023년 올해 9만 명이 넘는 개발자가 참여하면서 더욱 인기가 높아지는 모습을 보였습니다.

이번 글에서는 **Stack Overflow Developer Survey 2023** 에서 제가 좋아하는 [`Elixir`](https://elixir-lang.org/) 언어와, `Elixir` 기반의 Web framework 인 [`Phoenix`](https://www.phoenixframework.org/) 와 관련된 내용을 정리해보려 합니다.

## `Phoenix` 의 끊임 없는 인기

`Phoenix` 는 2022년에도 [가장 사랑받는 Web framework 로 선정](https://survey.stackoverflow.co/2022#section-most-loved-dreaded-and-wanted-web-frameworks-and-technologies) 되었었는데, 2023년에도 어김 없이 [가장 사랑받는 Web framework 로 선정](https://survey.stackoverflow.co/2023/#section-admired-and-desired-web-frameworks-and-technologies) 되었습니다.\
(2022년 Loved 에서 2023년 Admired 로 표현이 변경되었지만, 번역이 마땅치 않아 그대로 '사랑받는' 이라고 표현했습니다.)

무려 `Phoenix` 사용자의 **82%**가 `Phoenix` 에 대한 사랑을 표현했는데요.\
다른 후보들을 살펴보면 2위인 `Svelte` 는 74%, 일반적으로 많이 사용되는 `React` 63%, `Spring Boot` 59% 로, `Phoenix` 가 압도적인 사랑을 받는 것을 알 수 있었습니다.

<figure>
  <img src="/images/blog/20230624_phoenix.png" alt="Phoenix">
  <figcaption>사용자도 계속 늘어나길 기대해봅니다</figcaption>
</figure>

이는 `Phoenix` 가 친절한 문법, 간편한 동시성 처리, 높은 안정성, 테스트 용이성 등 `Elixir` 로부터 오는 장점을 그대로 갖추고 있어 prototype 부터 production 까지 매우 쉬운 개발 경험을 제공하고, Front-end 까지 한 번에 쉽게 작성할 수 있는 `Phoenix LiveView` 의 등장으로 압도적인 개발 퍼포먼스를 제공하기 때문으로 생각됩니다.

이번 설문에서 재밌는 부분은 **desired**(사용해보고 싶음) 과 **admired**(지난 1년 동안 사용했고, 앞으로도 사용하고 싶음) 로 구분해서 수집한 부분인데요.\
이에 대해 **Stack Overflow Developer Survey** 는 아래와 같이 말하고 있습니다.

>>>
To better gauge hype versus reality, we created a visualization that shows the distance between the proportion of respondents who want to use a technology (“desired”) and the proportion of users that have used the same technology in the past year and want to continue using it (“admired”). Wide distances means that momentum generated by the hype grows with hands-on use, and shorter distances means that the hype is doing much of the heavy lifting as far as general popularity is concerned.
>>>

이를 정리하면 아래와 같습니다.

- **desired** - **admired** 의 거리가 멀수록, 흥미가 실제 사용과 함께 증가하고 있다는 것을 의미한다.
- **desired** - **admired** 의 거리가 가까울수록, 흥미가 인기에 큰 영향을 주고 있다는 것을 의미한다.

즉, `React` 는 사람들의 흥미 때문에 과장된 면이 있고, `Phoenix` 는 실제 대비 매우 저평가 되어있다고 볼수 있습니다.

## `Elixir` 의 공고한 위치

`Elixir` 또한 2022년에 이어 2023년에도 [두 번째로 사랑받는 언어로 선정](https://survey.stackoverflow.co/2023/#section-admired-and-desired-programming-scripting-and-markup-languages) 되었습니다.

`Elixir` 사용자의 **73%**가 `Elixir` 에 대한 사랑을 보여주었습니다.

사랑받는 언어 1위는 `Rust` 가 계속해서 이어나가고 있습니다.

`Elixir` 는 **2.x%** 정도의 적은 사용자가 사용하는 언어이지만, 2022년에 비해 그 순위가 두 계단이나 상승하여 주목받았습니다.

>>>
A few technologies moved up a spot this year (Bash/Shell, C, Ruby, Perl, and Erlang) with two moving up two spots (Elixir and Lisp).
>>>

<figure>
  <img src="/images/blog/20230624_elixir.png" alt="Elixir">
  <figcaption>2022년에 비해 두 계단 상승!</figcaption>
</figure>

임금 면에서는 2022년과 마찬가지로 [6위에 올랐습니다.](https://survey.stackoverflow.co/2023/#section-top-paying-technologies-top-paying-technologies)

`Elixir` 와 비슷한 포지션을 갖는 언어인 `Clojure` 의 인기나 임금이 전반적으로 줄어든 것이 눈에 띕니다.

---

Web development 영역에서 `Phoenix` 를 넘어설 Web framework 는 당분간 없을 것 같습니다.\
아직 1.0 이 되지 않은 `Phoenix LiveView` 가 벌써부터 게임의 판도를 완전히 바꾸고 있는데, 같은 방향성으로 구현할 수 있는 언어가 잘 없기 때문입니다.

`Elixir` 도 `Python` 만큼은 아니지만 ML 분야로 계속 영역을 넓혀가고 있고, [`Livebook`](https://livebook.dev/) 의 등장으로 더욱 쉽고 재미있는 개발이 가능해졌습니다.

`Elixir` 에 관심이 가신다면 [`Elixir Korea Facebook Group`](https://www.facebook.com/groups/665804896887520), [`Elixir Korea discord`](https://discord.com/invite/mVNjg3e), [`Seoul Elixir Meetup`](https://www.meetup.com/ko-KR/Seoul-Elixir-Meetup/) 에 참여해보시는 것을 추천합니다.
