%{
title: "스타트업에 T3 Stack 을 추천한 이유",
description: "Full-stack TypeScript 개발을 위한 최고의 방법",
category: :dev,
cover_url: "/images/blog/20230409_cover.png",
tags: ["개발", "React", "Next.js", "tRPC", "Prisma", "T3 Stack", "TypeScript", "Full-stack"]
}

---

컨설팅을 했던 [비즈니스캔버스](https://company.typed.do/en) 에서 새로운 프로젝트들을 진행하게 되면서, 새로운 프로젝트는 어떤 스택으로 진행하면 좋을지 고민해볼 기회가 있었다.

결론적으로 새로운 스택으로 [`T3 Stack`](https://create.t3.gg/) 을 선택했다.\
이유는 모르겠지만 한국에서는 잘 알려지지 않은 것 같은데, 이번에 `T3 Stack` 을 선택하게된 이유를 정리해보려한다.

### 기존 스택

기존 프로젝트는 `React`(Front-end) + `Express`(Back-end) 조합으로 진행하고 있었고, 얼마 전 `Next.js` 에 대해서 공유를 해놓아서 어느 정도 이해도가 있는 상태였다.\
(`Next.js` 에 대해 정리한 글은 [Next.js 제대로 알기](./proper-understading-of-nextjs) 에서 확인할 수 있다)

### 요구사항

새로운 프로젝트들은 빠른 실험을 통해 그 중 무엇이 '될 놈'인지 찾는 것이 중요했다.\
따라서 새로운 스택은 제품을 빠르게 만들어볼 수 있도록 아래와 같은 요구사항을 고려했다.

- Web application: Mobile App 은 익숙하지도 않고 검수 등 시간이 많이 걸려서, 익숙하고 빠르게 배포할 수 있는 web application 으로 한다.
- 높은 생산성: 장기적인 확장성이나 안정성 보다, 빠른 실험을 위한 높은 생산성을 추구한다.
- 낮은 학습곡선: 쉽게 배울 수 있는 스택을 추구한다. 따라서 기존 지식을 활용할 수 있으면 좋다.

### 선택

위의 요구사항에 따라 `T3 Stack` 을 선택했다.\
선택한 이유는 아래와 같다.

- Web application: OK. Production-Ready.
- 높은 생산성: Full-stack web application 작성 가능, TypeScript 의 강점을 통해 생산성 향상(`tRPC` 등), web application 을 위한 기본 요소(DB client, Auth 등)가 잘 갖춰져있음.
- 낮은 학습곡선: React 를 사용하던 사람이라면 쉽게 적응 가능.

## T3 Stack

`T3 Stack` 은 별도의 framework 가 아니다.\
`TypeScript` 를 사용하는 웹 개발자들에게 이미 친숙하고 많이 사용되고 있는 framework, library 들을 잘 엮어서 Full-stack web application 을 만들어주는 프로젝트 생성툴이다.
[`create-react-app`](https://create-react-app.dev/) 이 하는 역할을 생각해보면 이해하기 쉽다.

<figure>
  <img src="/images/blog/20230409_t3_stack_parts.png" alt="Parts of T3 Stack">
  <figcaption>T3 Stack 은 Next.js, tRPC, Prisma, Tailwind CSS, Auth.js 로 이루어져있다.</figcaption>
</figure>

### 왜 Full-stack Web Application 인가?

`T3 Stack` 을 선택한 가장 큰 이유는 Full-stack web application 이기 때문이다.\
따라서 왜 Full-stack web application 을 선택했는지부터 설명하려고 한다.

왜 Front-end 와 Back-end 가 나뉘어지게 되었을까?

원래 web page 는 server 가 주가되는 web application 의 view 에 해당하는 영역이었다.\
현재에도 많은 MVC web framework 에서 간단한 HTML, CSS, JS 조합의 view 를 지원하고 있는 이유이다.\
따라서 client 에 개발할 영역이 많지 않았고, 별도의 영역으로 분리되지도 않았었다.

그러다가 SPA(Single Page Application) 가 대세가 되면서, web page 가 단순한 view 가 아니라 별도의 application 으로 발전하기 시작했다.\
SPA framework, library 들이 생겨나면서 개발할 영역이 많아졌고, 이에 따라 Front-end 라는 분야가 명확히 분리되었다.

하지만 client 가 별도의 application 이 되면서 더 비효율적인 부분들도 발생했다.

먼저, server 에 있는 state 를 client 에서도 별도로 관리하기 시작했는데, 동일한 state 를 양쪽에서 관리하면서 이를 sync 하는 일은 **굉장히 어려운** 영역이다.\
(server 에 반영된 변경을 client 에서는 어떻게 처리해야할지 고민한 경험이 떠오르지 않는가?)\
이 때문에 오랜 시간동안 client 에서 state 를 관리하는 좋은 방법을 찾기 위한 시도가 이어져왔다.\
(대표적인 것으로 [`TanStack Query(React Query)`](https://tanstack.com/query/v3/) 가 있다.)

다음으로 server 에서는 API 를 작성해야하고 client 에서는 server 의 API 를 호출하는 부분을 작성해야하게 되었다.\
지금이야 당연하게 느껴지지만 Front-end 와 Back-end 가 서로 나뉘어서 API 관련 작업을 하는 것은 여러가지 비효율을 발생시킨다.\
(API 변경이 제대로 전달되지 않아서 문제가 생긴 경험이 떠오르지 않는가?)
이 문제 또한 그동안 해결을 위한 여러가지 시도가 이어져오고 있다.\
(대표적인 것으로 [`gRPC`](https://grpc.io/) 가 있다.)

이러한 비효율 때문에 다시 Full-stack web application 으로 돌아가고자 하는 움직임이 있다.\
(대표적으로 [`Phoenix LiveView`](https://github.com/phoenixframework/phoenix_live_view)!)

server-client 가 분리되어있지 않은 Full-stack web application 을 만들면서, thin client 혹은 그에 가까운 방식으로 개발을 하면 state 관리가 매우 쉬워지고 API 작성과 호출로 인한 불필요한 작업이 사라진다.

<figure>
  <img src="/images/blog/20230409_thick_client_thin_client.jpg" alt="Thick Client vs Thin Client">
  <figcaption>Thin client 개념이 궁금하다면 <a href="https://youtu.be/lAaD-6OQSHE?t=216" target="_blank">liftIO 2022 : 웹 개발의 모순과 Elixir가 특효약인 이유 - 한국축산데이터 CTO Max(이재철)</a> 영상을 참고</figcaption>
</figure>

`T3 Stack` 에서는 이 역할을 [`tRPC`](https://trpc.io/) 가 맡고 있다.

혹시나 오해를 막기 위해, Full-stack 개발자가 되라는 것과는 별개의 이야기이다.\
하나의 application 에서도 잘 역할을 나눠서 일할 수 있다.

### T3 Stack 구성요소

TBD

---

`React` 를 사용하는 곳이라면 client application 으로 `Next.js` 를, `Next.js` 를 사용하는 곳이라면 Full-stack application 으로 `T3 Stack` 을 고려해봄직 하다고 생각한다.

더 궁금하다면 [The BEST Stack For Your Next Project](https://youtu.be/PbjHxIuHduU) 도 참조!
