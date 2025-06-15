%{
title: "Ash Weekly: Issue #17 리캡",
description: "Ash AI, ElixirConf EU 2025, Phoenix.new, Phoenix.Sync, AtomVM, Hologram, LangSchema.",
category: :dev,
cover_url: "/images/blog/20250526_ash_weekly_17_recap_cover_ko.png",
tags: ["Ash", "Ash Weekly", "Ash AI", "ElixirConf", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/) 는 현재 Elixir 에서 가장 핫하고 표준이 되어가고 있는 선언형 프레임워크입니다. Ash 생태계에서 일어나고 있는 일들을 매주 알려주고 있는 [Ash Weekly]+(https://ashweekly.substack.com/) 를 정리해서 전달드립니다.

원문: [Ash Weekly: Issue #17]+(https://ashweekly.substack.com/p/ash-weekly-issue-17)

## [Ash AI]+(https://github.com/ash-project/ash_ai) 출시

요즘 어플리케이션을 개발하면서 AI(LLM) 적용을 고민하지 않는 개발자는 거의 없을 것이라고 생각됩니다. 이런 상황에서 Ash 라는 강력한 선언형 프레임워크에 AI 를 위한 extension 이 추가되는 것은 당연히 예견된 일이었습니다.

Ash AI repo 는 2024년 8월에 생성되어 그 컨셉에 대해 기대를 모았었고, 이번 ElixirConf EU 2025 에서 정식으로 발표되었습니다. 저도 Ash AI 를 2025년 3월부터 본격적으로 사용하면서 기여를 하고 있습니다. (현재 #2 기여자)

Ash AI 는 아래와 같은 기능들을 제공합니다.

- **Prompt-bakced Actions**: AI 를 이용해 결과를 반환하는 generic action 을 쉽게 선언할 수 있습니다.
- **Tool Definition**: 이미 선언한 action 을 LLM 의 tool 로 쉽게 노출할 수 있습니다.
- **Vectorization**: resource 에 대해 RAG 를 쉽게 구현할 수 있습니다.
- **MCP Server**: 개발을 위해 어플리케이션 정보를 제공하는 개발용 MCP server, production 을 위해 내부 action 을 tool 로 제공하는 MCP server 를 쉽게 만들 수 있습니다.

참고: [Ash AI: A comprehensive LLM toolbox for Ash Framework]+(https://alembic.com.au/blog/ash-ai-comprehensive-llm-toolbox-for-ash-framework)

## [ElixirConf EU 2025]+(https://www.elixirconf.eu/) Wrap up

2025년 5월 14-16일 동안 폴란드 크라쿠프에서 ElixirConf EU 2025 가 열렸습니다.

ElixirConf 는 Elixir 언어 사용자들에게 가장 큰 행사로, 1년에 크게 상반기에 EU / 하반기에 US 가 열리는데요. 가장 큰 행사 중 하나인 만큼 흥미로운 내용이 많았습니다. 그 중 주요한 몇 가지가 이번 뉴스레터에서 공유되었습니다.

### [Code generators are dead, long live code generators - Chris McCord]+(https://www.youtube.com/watch?v=ojL_VHc4gLk)

Chris MaCord 가 속한 [fly.io]+(https://fly.io/) 에서 [Phoniex.new]+(https://phoenix.new/) 라는 리모트 코딩 에이전트 서비스를 내놓았습니다.
Zach Daniel 은 Phoenix.new 를 IDE + Cloud + Elixir & Phoniex 에 특화된 코딩 어시스턴트라고 표현했네요.

AI 의 미래에 대해 어떻게 생각하든, Elixir 에서도 AI 와 관련된 재밌는 시도들이 나오는 것을 매우 긍정적으로 평가하고 있습니다.
아직은 Waitlist 를 통해서만 사용 가능하니 궁금하신 분들은 신청해보세요.

### [Introducing Phoenix.Sync - James Arthur]+(https://www.youtube.com/watch?v=4IWShnVuRCg)

[Phoenix.Sync]+(https://hexdocs.pm/phoenix_sync) 는 Phoenix 에 [Electric]+(https://electric-sql.com/) 을 밀접하게 결합하여 real-time sync 를 구현하기 쉽게 만드는 시도입니다.

Electric 은 뛰어난 사용자 경험을 제공하는 local-first 어플리케이션이 많아지고 있는 추세에서 이를 구현하기 위한 방법으로 관심있게 지켜보고 있었기 때문에 더 기대가 됩니다.
LiveView 가 아닌 React, mobile 환경 등 기존에 Electric 이 잘 구축해놓은 front-end 환경들과 연동된다는 점에서, Phoenix 의 외연이 더 넓어질 수 있는 좋은 기회가 될 것 같습니다.

### The AtomVM and New Horizons for Elixir

[AtomVM]+(https://www.atomvm.net/) 은 BEAM 의 lightweight 구현으로, IoT 디바이스와 브라우저에서 Erlang(그리고 Elixir)를 지원하는 것을 목표로 하는 프로젝트입니다.

ElixirConf EU 2025 에서는 브라우저에서의 구동에 좀 더 포커스 되었던 것 같은데, hexdocs 의 코드블럭을 브라우저에서 바로 시연하는 것도 가능했던 것 같네요.
앞으로 이를 기반으로 어떤 시도들이 또 생겨날지 기대됩니다.

### Hologram: Building Rich UIs with Elixir Running in the Browser

[Hologram]+(https://hologram.page/) 은 Elixir 로 front-end/back-end 모두를 작성하도록 하는 것을 목표로 하는 프로젝트입니다.

LiveView 가 back-end 로 대부분을 처리하고 매우 얇은 front-end 를 추구하는 것에 비해, Hologram 은 기존의 어플리케이션들과 같이 front-end 도 자체 state 를 갖는 방향으로 가지만 이를 Elixir 로 쉽게 작성하게 하려는 것 같네요.
처음 출시되었을 때 설명을 읽어보았지만 아직 컨셉을 완전히 이해하지는 못하고 있는데, 과연 이런 방법으로 어느 정도 수준까지의 구현이 가능할까 궁금합니다.

## 프로젝트 홍보 - [LangSchema]+(https://github.com/nallwhy/lang_schema)

Ash AI 는 현재 여러 기능들이 OpenAI 의 모델만 사용할 수 있게 되어있습니다.
이는 AI provider 의 JSON schema spec 이 서로 다르기 때문인데요, 이런 문제를 해결하기 위해 [LangSchema]+(https://github.com/nallwhy/lang_schema) 라는 library 를 구현했습니다.
Abstract schema 라는 개념을 두어 이를 이용해 코드를 작성하면, AI provider 의 JSON schema spec 에 맞춰 변환해주는 컨셉입니다.
Ash AI 에서 사용하는 것도 [논의]+(https://github.com/ash-project/ash_ai/issues/24) 중인데, AI 관련해서 코드 작성할 때 써보시면 어떨까 합니다.
