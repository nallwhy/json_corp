%{
title: "Ash Weekly: 第18号まとめ",
description: "AshPhoenix.Plug.CheckCodegenStatus、mix ash.codegen --dev、Shared Action Context、UsageRules、ash_ai.gen.chatの改善、Igniter.Scribe。",
category: :dev,
cover_url: "/images/blog/20250615_ash_weekly_18_recap_cover_ja.png",
tags: ["Ash", "Ash Weekly", "UsageRules", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/) は現在Elixirで最も注目されており、標準となりつつある宣言型フレームワークです。[Ash Weekly]+(https://ashweekly.substack.com/) はAshエコシステムで起きている出来事を毎週伝えており、その内容をまとめてお届けします。

原文: [Ash Weekly: Issue #18]+(https://ashweekly.substack.com/p/ash-weekly-issue-18)

## AshPhoenix.Plug.CheckCodegenStatus

`AshPhoenix.Plug.CheckCodegenStatus`プラグを利用すると、未実行のDBマイグレーションが存在する場合にPhoenixでマイグレーションを促す案内が表示されるのと同様に、Ashでコード変更によるコード生成が未実行の場合に親切な案内画面が表示されます。\
提供されるボタンを押すことで、その操作をすぐに実行することもできます。

![CheckCodegenStatus Page](/images/blog/20250615_check_codegen_status.jpg)

## --devマイグレーション

上記で言及した`mix ash.codegen`を実行する際、`--dev`オプションを使うと名前を付けることなくコード生成を進め、最後に`mix ash.codegen`で名前を付けて再実行すると、それまでに蓄積された作業をまとめてコード生成してくれます。

私たち[DevAllCompany]+(https://www.chungoose.kr/)ではこのような機能を自作して使っていましたが、公式にサポートされて嬉しいです。

```shell
# 作業を蓄積した後
$ mix ash.codegen --dev

$ mix ash.codegen --dev

# ここで一度に再生成
$ mix ash.codegen create_user
```

## Shared Action Context

Ashのアクションで使用していたcontextに、そのアクションから呼び出されるネストされたアクションにも伝播する`shared`キーが追加されました。\
伝播される値なので、大きすぎる値は入れないようにしましょう。並行性が使われる場合、プロセス間でコピーされるため注意が必要です。

```elixir
MyApp.Domain.Resource.action(..., context: %{shared: %{key: "value"}})
```

## usage-rules.md

最近vibe codingをよくしていますか？Elixirは変化が速く、学習データが少ないため、LLMによるvibe codingの結果が満足できないことも多いですが、これをある程度解決できる[UsageRules]+(https://github.com/ash-project/usage_rules)プロジェクトが登場しました。

UsageRulesの仕組みはとてもシンプルです。\
各ライブラリにある`usage-rules.md`ファイルを集めて1つのファイルにまとめ、LLMがコンテキストとして使いやすくします。\
例えば[Ashのusage-rules.md]+(https://github.com/ash-project/ash/blob/main/usage-rules.md)には、Ashをどのように理解し使うべきかがまとめられています。\
自分のプロジェクトで`Ash`や`Ash AI`を使っている場合、以下のように実行すると、2つのライブラリの`usage-rules.md`をまとめて1つのファイルにしてくれます。

```shell
$ mix usage_rules.sync CLAUDE.md ash, ash_ai
```

こうすることでClaudeを使う際に、その内容をコンテキストとしてvibe codingができます。\
`--all`オプションで使用中のすべてのライブラリから取得することも可能です。

## ash_ai.gen.chatの改善

`mix ash_ai.gen.chat`で生成されるコードでは、LLMのツールコールやツール結果が保存されるようになりました。\
以前の会話を読み込んだ際にこれらの情報がないとコンテキストの多くが失われてしまいますが、今回の変更で過去の会話を引き継ぐ性能が大幅に向上したと思われます。\
ただし、ツール結果が非常に大きくなることもあるため、保存やLLMへの再送信が常に最良かどうかは検討の余地があります。

## Igniter.Scribe

[Igniter]+(https://github.com/ash-project/igniter)は、ライブラリのインストールなどで必要なコード変更を自動で行うのを助けるライブラリです。\
このとき、マニュアルガイド部分がコード変更に応じて自動で更新されず、手動で修正する必要があった点が改善されました。

自作ライブラリで`Igniter`を使っていた方には朗報です。
