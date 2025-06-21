%{
title: "Ash Weekly: 第19号まとめ",
description: "Ashホームページ/ドキュメント刷新、AshAdminファイルアップロード、AshAI非OpenAI LLM、UsageRules --sync-to-folderフラグ、Reactorドキュメント刷新、新しいAsh拡張。",
category: :dev,
cover_url: "/images/blog/20250621_ash_weekly_19_recap_cover_ja.png",
tags: ["Ash", "Ash Weekly", "AshAdmin", "UsageRules", "Reactor", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/) は現在Elixirで最も注目され、標準となりつつある宣言型フレームワークです。[Ash Weekly]+(https://ashweekly.substack.com/) はAshエコシステムで起きている出来事を毎週伝えており、その内容をまとめてお届けします。

原文: [Ash Weekly: Issue #19]+(https://ashweekly.substack.com/p/ash-weekly-issue-19)

## ホームページ & What is Ashガイド刷新

Ashは他の言語では一般的でないコンセプトのフレームワークなので、その概念を理解するには追加の説明が必要です。

これまでホームページやドキュメントの説明がやや不足していましたが、今回[Ashホームページ]+(https://ash-hq.org/)やドキュメントの[What is Ash?]+(https://hexdocs.pm/ash/what-is-ash.html)セクションがアップデートされ、より分かりやすくなりました。

Ashがまだよく分からない方は、ぜひ一度ご覧ください！

## AshAdminのファイルアップロード対応

[AshAdmin]+(https://github.com/ash-project/ash_admin)は、Ashの宣言から自動で管理画面を生成するライブラリです。

これまでファイルアップロードはできませんでしたが、今回`:file`型の引数に対して自動でファイルアップロードがサポートされるようになりました。（こうしたAshエコシステムの進化は多くがコミュニティメンバーによるものです👍）

デザインはまだあまり洗練されていませんが、今後の改善に期待です。

## prompt-backed actionsでOpenAI以外のモデルも対応

[AshAI]+(https://github.com/ash-project/ash_ai)はAshベースでAI関連の処理を簡単に作れるライブラリで、prompt-backed actionはLLMを使ってアクションを実行する機能です。

理解のため、AshAIのREADME.mdにある例を紹介します。

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

従来はOpenAIモデルのみ利用可能でしたが、さまざまなアダプターのサポートにより、他のプロバイダーのLLMも利用できるようになりました。

## UsageRules --sync-to-folderフラグ

[UsageRules]+(https://github.com/ash-project/usage_rules)は各ライブラリの`usage-rules.md`を集め、LLMのコンテキストとして使えるようにするプロジェクトです。

今回`--sync-to-folder`フラグが追加され、すべての内容を1つのファイルにまとめる代わりに、各ファイルへのリンク形式で利用できるようになりました。

例:
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

この方法だとすべての内容をコンテキストに入れないため、トークン消費が減りますが、必要なファイルを探すのに時間がかかる場合もあります。用途に応じて使い分けてください。

## Reactorドキュメント刷新

[Reactor]+(https://github.com/ash-project/reactor)は[Sagaパターン]+(https://learn.microsoft.com/en-us/azure/architecture/patterns/saga)を簡単に使えるようにするライブラリです。Sagaパターンは分散トランザクションの実装に適しています。

今回[ドキュメント]+(https://hexdocs.pm/reactor/readme.html)が刷新されたので、Sagaパターンに興味のある方はぜひご覧ください。

## Changelogにコントリビューター名が記載

Ashプロジェクトに貢献すると、リリースノートに名前が記載されるようになりました。コミュニティ構築への取り組みが伺えます。

## コミュニティ拡張

### [AshNeo4j]+(https://github.com/diffo-dev/ash_neo4j)

Ashで代表的なグラフデータベース[Neo4j]+(https://neo4j.com/)をサポートするライブラリです。

### [AshOutstanding]+(https://github.com/diffo-dev/ash_outstanding)

Ashで[Outstanding]+(https://github.com/diffo-dev/outstanding)プロトコルをサポートするライブラリです。

Outstandingプロトコルは、期待する値が満たされているか、満たされていない場合はどこが未達かを簡単に把握できる仕組みのようです。

### [AshCommanded]+(https://github.com/accountex-org/ash_commanded)

AshでCQRS/ESパターンを簡単に適用できる[Commanded]+(https://github.com/commanded/commanded)をサポートするライブラリです。

CQRS/ESパターンは以前から試してみたいと思いつつまだ使ったことがありませんが、最近発表された[AshEvents]+(https://github.com/ash-project/ash_events)もあるので、ぜひ挑戦してみたいです。

## LLMs & Elixir: Windfall or Deathblow

最近、Zach Danielによる[LLMs & Elixir: Windfall or Deathblow]+(https://www.zachdaniel.dev/p/llms-and-elixir-windfall-or-deathblow?utm_source=substack&utm_campaign=post_embed&utm_medium=web)がHacker Newsで話題になりました。

最近の[Tidewave]+(https://tidewave.ai/)、[Phoenix.new](https://phoenix.new/)、[UsageRules]+(https://github.com/ash-project/usage_rules)など、ElixirでAIを活用したコーディングをより簡単にする取り組みとも方向性が一致しています。
