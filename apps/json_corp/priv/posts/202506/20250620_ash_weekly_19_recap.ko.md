%{
title: "Ash Weekly: Issue #19 리캡",
description: "Ash 홈페이지/문서 개선, AshAdmin file upload, AshAI non-OpenAI LLM, UsageRules --sync-to-folder flag, Refactor 문서 개선, 새로운 Ash extensions.",
category: :dev,
cover_url: "/images/blog/20250621_ash_weekly_19_recap_cover_ko.png",
tags: ["Ash", "Ash Weekly", "AshAdmin", "UsageRules", "Refactor", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/) 는 현재 Elixir 에서 가장 핫하고 표준이 되어가고 있는 선언형 프레임워크입니다. Ash 생태계에서 일어나고 있는 일들을 매주 알려주고 있는 [Ash Weekly]+(https://ashweekly.substack.com/) 를 정리해서 전달드립니다.

원문: [Ash Weekly: Issue #19]+(https://ashweekly.substack.com/p/ash-weekly-issue-19)

## 홈페이지 & What is Ash Guide 개편

Ash 는 아무래도 다른 언어에서는 일반적으로 존재하는 컨셉의 프레임워크가 아니다보니, 사람들이 그 개념을 이해하기 위해서는 별도의 설명이 필요한 편입니다.

하지만 기존에는 이를 위한 설명이 홈페이지나 문서에 좀 부족했었는데요, 이번에 [Ash 홈페이지]+(https://ash-hq.org/), 문서의 [What is Ash?]+(https://hexdocs.pm/ash/what-is-ash.html) 섹션의 내용이 업데이트 되어 더 이해하기 쉬워졌습니다.

아직 Ash 가 잘 이해되지 않으신다면, 한 번 들려보시길!


## AshAdmin 의 File Upload 지원

[AshAdmin]+(https://github.com/ash-project/ash_admin) 은 Ash 의 선언들로 admin 페이지를 자동으로 생성해주는 library 입니다.

기존에는 여기서 file upload 를 할 수 없었는데요. 이번에 `:file` type 의 argument 에 대해 자동으로 file upload 가 지원되도록 업데이트 되었습니다. (이런 Ash 생태계의 많은 발전들은 커뮤니티 멤버들로부터 이루어지고 있습니다. 👍)

아직 디자인이 좀 안예쁘긴 한데, 이 부분도 개선될 수 있으면 좋겠네요 ㅎㅎ

## prompt-backed actions 에서 OpenAI 이외의 모델도 지원

Ash 를 기반으로 AI 관련 작업을 쉽게 만들어주는 [AshAI]+(https://github.com/ash-project/ash_ai) 의 prompt-backed action 은 action 이 LLM 을 통해 수행되도록 하는 기능입니다.

이해를 위해 AshAI README.md 에 있는 예제를 가져와보겠습니다.

```elixir
action :analyze_sentiment, :atom do
  constraints one_of: [:positive, :negative]

  description """
  Analyzes the sentiment of a given piece of text to determine if it is overall positive or negative.
  """

  argument :text, :string do
    allow_nil? false
    description "The text for analysis"
  end

  run prompt(
    LangChain.ChatModels.ChatOpenAI.new!(%{ model: "gpt-4o"})
  )
end
```

기존에는 OpenAI 모델만 사용 가능했었는데, 다른 특성을 가진 LLM 과도 연결 가능해주게 하는 여러 adapter 가 지원됨에 따라 이외의 다양한 provider 의 LLM 모델이 사용가능해졌습니다.

## UsageRules --sync-to-folder flag

[UsageRules]+(https://github.com/ash-project/usage_rules) 는 각 library 의 `usage-rules.md` 파일을 모아, LLM 에서 context 로 사용할 수 있게 해주는 프로젝트입니다.

이번에 `--sync-to-folder` flag 가 추가되었는데, 하나의 파일에 모든 내용을 넣는 대신 각 파일을 링크하는 형식으로 사용할 수 있습니다.

e.g.
```markdown
<-- usage-rules-start -->
<-- ash-start -->
## ash usage
[ash usage rules](deps/ash/usage-rules.md)
<-- ash-end -->
<-- ash_ai-start -->
## ash_ai usage
[ash_ai usage rules](deps/ash_ai/usage-rules.md)
<-- ash_ai-end -->
<-- usage-rules-end -->
```

이렇게 하면 모든 내용을 context 에 다 집어넣지 않으니, token 사용량이 줄어드는 대신 필요한 파일을 찾아서 탐색하는데 시간이 더 걸릴 수 있겠네요. 원하는 방향에 따라 적용하시면 될 것 같습니다.

## Reactor documentation overhaul

[Reactor]+(https://github.com/ash-project/reactor) 는 [Saga 패턴]+(https://learn.microsoft.com/en-us/azure/architecture/patterns/saga)을 쉽게 사용할 수 있게 도와주는 library 입니다. Saga 패턴은 distributed transcation 을 구현할 때 사용하기 좋죠.

이번에 [문서]+(https://hexdocs.pm/reactor/readme.html) 가 개편되었다고 하니, Saga 패턴 사용에 관심있으셨던 분들은 봐보시면 좋을듯 합니다.

## Contributor Names in Changelogs

Ash 프로젝트들에 기여하는 경우 release note 에 이름이 명시될 것이라고 합니다. 커뮤니티 구축에 힘쓰는 모습입니다.

## Community Extensions

### [AshNeo4j]+(https://github.com/diffo-dev/ash_neo4j)

Ash 에 대표적인 Graph Database 인 [Neo4j]+(https://neo4j.com/) 를 지원하는 library 입니다.

### [AshOutstanding]+(https://github.com/diffo-dev/ash_outstanding)

Ash 에 [Outstading]+(https://github.com/diffo-dev/outstanding) protocol 을 지원하는 library 입니다.

Outstading protocol 은 기대하는 값이 있을 때 현재 이것이 충족되었는지, 충족되지 않았다면 어떤 부분이 충족되지 않았는지 쉽게 알 수 게 해주는 것 같습니다.

### [AshCommanded]+(https://github.com/accountex-org/ash_commanded)

Ash 에 CQRS/ES 패턴을 적용하기 쉽게 해주는 [Commanded]+(https://github.com/commanded/commanded) 를 지원하는 library 입니다.

CQRS/ES 패턴은 늘 해보고 싶은 대상으로 남아있고 아직 적용해본적은 없는데, 얼마전에 발표된 [AshEvents]+(https://github.com/ash-project/ash_events) 도 있고 하니 한 번 도전해봐야겠네요.

## LLMs & Elixir: Windfall or Deathblow

최근 Zach Daniel 이 작성한 [LLMs & Elixir: Windfall or Deathblow]+(https://www.zachdaniel.dev/p/llms-and-elixir-windfall-or-deathblow?utm_source=substack&utm_campaign=post_embed&utm_medium=web) 가 Hacker News 에서 화제가 되었었습니다.

최근 [Tidewave]+(https://tidewave.ai/), [Phoenix.new](https://phoenix.new/), [UsageRules]+(https://github.com/ash-project/usage_rules) 등 Elixir 에서 AI 의 도움을 받는 코딩을 더 쉽게 하도록 해주는 작업들의 방향성과도 이어지는 내용입니다.
