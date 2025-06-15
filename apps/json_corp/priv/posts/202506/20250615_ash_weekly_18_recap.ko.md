%{
title: "Ash Weekly: Issue #18 리캡",
description: "AshPhoenix.Plug.CheckCodegenStatus, mix ash.codegen --dev, Shared Action Context, UsageRules, ash_ai.gen.chat 개선, Igniter.Scribe.",
category: :dev,
cover_url: "/images/blog/20250615_ash_weekly_18_recap_cover_ko.png",
tags: ["Ash", "Ash Weekly", "UsageRules", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/) 는 현재 Elixir 에서 가장 핫하고 표준이 되어가고 있는 선언형 프레임워크입니다. Ash 생태계에서 일어나고 있는 일들을 매주 알려주고 있는 [Ash Weekly]+(https://ashweekly.substack.com/) 를 정리해서 전달드립니다.

원문: [Ash Weekly: Issue #18]+(https://ashweekly.substack.com/p/ash-weekly-issue-18)

## AshPhoenix.Plug.CheckCodegenStatus

`AshPhoenix.Plug.CheckCodegenStatus` plug 를 이용하면, 진행되지 않은 DB migration 이 존재할 때 Phoniex 에서 migration 하라는 안내를 띄워주던 것 처럼, Ash 에서 아직 코드 변경에 따른 code generation 이 진행되지 않은 경우 친절하게 안내해주는 화면을 띄워줍니다.\
제공되는 버튼을 눌러서 해당 동작을 바로 수행할 수도 있습니다.

![CheckCodegenStatus Page](/images/blog/20250615_check_codegen_status.jpg)

## --dev migrations

위에서 언급 된 `mix ash.codegen` 을 수행할 때 `--dev` 옵션을 사용하면 이름 붙일 고민없이 codegen 을 수행하다가, 마지막에 `mix ash.codegen` 에 이름을 붙여서 다시 사용하면 그동안에 쌓인 작업들을 묶어서 codegen 을 해줍니다.

저희 [데브올컴퍼니]+(https://www.chungoose.kr/)는 작업 이런 기능을 직접 구현해서 사용하고 있었는데, 자체적으로 지원된다니 편하겠네요.

```shell
# 작업을 누적한 후
$ mix ash.codegen --dev

$ mix ash.codegen --dev

# 여기서 한 번에 다시 생성
$ mix ash.codegen create_user
```

## Shared Action Context

Ash 의 action 들에서 사용하던 context 에, 해당 action 에서 불리우는 nested action 들에도 전달되는 `shared` key 가 추가되었습니다.\
계속 전달되는 값이다보니 너무 큰 값을 넣지는 말라고 하네요. 동시성이 사용될 때는 process 간에 복사가 되기 때문에 조심해야 합니다.

```elixir
MyApp.Domain.Resource.action(..., context: %{shared: %{key: "value"}})
```

## usage-rules.md

요즘 vibe coding 많이들 하고 계신가요? Elixir 는 상대적으로 변화가 빠르고 학습할 데이터가 적다보니 LLM 이 학습할 데이터가 적어 vibe coding 의 결과가 마음에 들지 않을 때가 많은데요.\
이를 어느 정도 해결해줄 수 있는 [UsageRules]+(https://github.com/ash-project/usage_rules) 프로젝트가 나왔습니다.

UsageRules 는 원리는 매우 간단합니다.\
각 library 마다 있는 `usage-rules.md` 파일을 모아서 하나의 파일로 만들어줘, LLM 이 context 로 사용하기 쉽게 해줍니다.\
예를 들어 [Ash 의 usage-rules.md]+(https://github.com/ash-project/ash/blob/main/usage-rules.md) 에는 이렇게 Ash 를 어떻게 이해하고 사용해야하는지 정리되어 있습니다.\
내가 `Ash`, `Ash AI` 를 사용하는 프로젝트에서 아래와 같이 쓰면, 두 library 의 `usage-rules.md` 파일을 묶어서 하나의 파일로 만들어주는 것이죠.

```shell
$ mix usage_rules.sync CLAUDE.md ash, ash_ai
```

그러면 Claude 를 사용할 때 해당 내용들을 context 로 사용해서 vibe coding 을 할 수 있겠죠?\
`--all` 옵션으로 사용하고 있는 모든 library 에서 가져오는 것도 가능합니다.

## ash_ai.gen.chat improvements

`mix ash_ai.gen.chat` 로 생성되는 코드에서 이제 LLM 의 tool calls, tool results 를 저장합니다.\
이전 대화를 불러왔을 때 해당 정보들이 없으면 context 의 많은 부분이 유실되는 것이라, 이번 변경으로 훨씬 이전 대화를 불러왔을 때 대화를 이어나가는 성능이 높아졌을 것 같네요.\
하지만 개인적으로는 tool results 는 가끔 너무 클 때가 있어서 저장하거나 LLM 에 다시 다 전달하는 것만이 좋은 방법일까라는 고민이 있기도 합니다.


## Igniter.Scribe

[Igniter]+(https://github.com/ash-project/igniter) 는 library 의 설치 등에서 필요한 코드 변경을 자동으로 수행할 수 있도록 도와주는 library 인데요.\
이 때 manual guides 부분이 코드 변경에 따라 자동으로 변경되지 않아 직접 수정해줘야하는 부분이 개선되었습니다.

직접 library 를 제작하면서 `Igniter` 를 사용하던 분들에게는 희소식이겠네요.
