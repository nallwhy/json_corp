%{
title: "Next.js 제대로 알기",
description: "Next.js != Server Side Rendering Framework",
category: :dev,
cover_url: "/images/blog/20230202_cover.png",
tags: ["개발", "React", "Next.js"]
}

---

여러 글들에서 [`Next.js`](https://nextjs.org/) 를 'Server Side Rendering(이하 SSR) Framework' 혹은 SSR 를 할 때만 사용하는 Framework 처럼 설명한다.

아마 Single-Page Application(SPA) 를 개발하는 많은 개발자들이 SSR 에서 가장 불편함을 겪고 있었기 때문에 그렇게 설명하게 되는 것이겠지만, 이는 오해를 만들 여지가 있는 설명이기 때문에 `Next.js` 가 무엇인지에 대해 제대로 얘기해보려 한다.

### `Next.js` 란 무엇인가?

`Next.js` 홈페이지(https://nextjs.org) 에 `Next.js` 는 'The React Framework for the Web' 이라고 설명되어있다.

<figure>
  <img src="/images/blog/20230202_nextjs.png" alt="Next.js is the React Framework for the Web">
</figure>

React 를 이용한 Web application 을 만들기 위한 framework 임을 나타낸다.

### 그러면 `React` 는 무엇인가?

`React` 홈페이지(https://reactjs.org) 에 `React` 는 'A JavaScript library for building user interfaces' 라고 설명되어있다.

`React` 와 곧잘 비교되는 `Angular` 의 설명은 아래와 같다.\
(https://angular.io/docs)

>>>
Angular is an application-design framework and development platform for creating efficient and sophisticated single-page apps.
>>>

`React` 는 library 로 표현되고, `Angular` 는 framework, platform 으로 표현된다.\
이는 `Angular` 와는 달리 `React` 가 application 이 아닌 그 중 일부인 UI 만 담당한다는 사실이 드러나는 부분이다.

`React` 는 철저하게 UI 만을 다뤄왔고, 그렇기 때문에 그동안 `React` 를 이용하는 application(이하 `React` application) 을 만들기 위해 필요한 나머지 부분들은 third-party library 들이 만들어지면서 해결되어왔다.

그러나 이러한 `React` 생태계는 여러가지 문제점들 또한 가지게 되었다.

- 서로 다른 third-party library 사이의 궁합이 보장되지 않음
- Best practice 의 부재
- 어떻게든 돌아가는 결과물은 나오니 다들 제멋대로 개발
- third-party library 들이 `React` 의 발전과 발맞추어 나가지 못하고 뒤늦게 쫓아가거나 탈락함

그래서 나는 `React` 를 하기 싫어했었다.\
뭐 한 가지를 제대로 하려고 해도 그 답을 찾는데 너무 오래걸렸다.

### `Next.js` 는 어떻게 기존 `React` 생태계의 문제를 해결했는가?

`React` 는 쓰기 싫었지만 `Next.js` 를 접하고서 '이건 써도 되겠다'라고 생각했다.

`Next.js` 는 위에서 말했던 `React` 생태계의 문제점을 해결하기 위해, `React` application 을 만들기 위해 필요한 나머지 부분들을 다 채워주는 framework 을 제시했다.

<figure>
  <img src="/images/blog/20230202_next_app.png" alt="Next.js Framework">
  <figcaption>Next.js 로 React application 을 손쉽게 만들 수 있다.</figcaption>
</figure>

`Next.js` 는 application 을 만들기 위해 아래와 같은 것들이 필요하다고 말한다.\
(https://nextjs.org/learn/foundations/about-nextjs/what-is-nextjs)

- User Interface
- Routing
- Data Fetching
- Rendering
- Integrationsh
- Infrastructure
- Performance
- Scalability
- Developer Experience

SSR 는 `Next.js` 가 제공하는 많은 기능 중 `Rendering` 의 한 파트로 포함되어 있을 뿐이다.

`Next.js` 는 `React` 생태계의 first-party 급 framework 로 자리잡았다.

서로 궁합이 보장되는 feature 들의 조합이, 명확한 best practice 와 함께 제공되고, 그렇기 때문에 `React` 측과 긴밀한 협업도 가능하다.

Trusted partner 라는 관점에서 `React` 의 **second-party** 로 볼 수 있을 것 같다.

이제 기존에 비해 매우 쉽고 신뢰할 수 있는 `React` application 을 만들 수 있게 되었다.

### 마무리

`React` application 을 만들기 위해 꼭 `Next.js` 를 사용할 필요는 없다. 비어있는 부분들을 다른 framework, library 들로 조합하거나 직접 만들어서도 application 을 만들 수 있고, 기존에 우리는 그렇게 해왔다.

하지만 딱히 다른 이유가 있는 것이 아니라면, 앞으로 `React` application 을 만들 때는 `Next.js` 를 사용하는 것을 추천하고 싶다.

그러면 기존에 `React` 를 하면서 겪던

- Application 을 만들기 위해 어떤 library 조합을 사용할지 고민하고
- 여러 library 들을 사용하면서 생기는 원인을 알 수 없는 에러에 스트레스 받고
- 그 답을 쉽게 찾을 수 없어 Stack Overflow 의 솔루션들을 하나하나 적용해보면서 해결되기를 바라고
- 사용하던 library 는 새로운 `React` version 을 지원하지 않아 업데이트에 발목 잡히는

고통들이 많이 해결될 것이다.
