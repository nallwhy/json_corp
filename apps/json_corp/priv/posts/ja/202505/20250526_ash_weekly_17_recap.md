%{
title: "Ash Weekly: 第17号 まとめ",
description: "Ash AI、ElixirConf EU 2025、Phoenix.new、Phoenix.Sync、AtomVM、Hologram、LangSchema。",
category: :dev,
cover_url: "/images/blog/20250526_ash_weekly_17_recap_cover_ja.png",
tags: ["Ash", "Ash Weekly", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/)は、現在Elixirコミュニティで最も注目され、標準化が進んでいる宣言的フレームワークです。今回は、Ashエコシステムの最新情報を毎週お届けしている[Ash Weekly]+(https://ashweekly.substack.com/)の内容をまとめてご紹介します。

原文: [Ash Weekly: Issue #17]+(https://ashweekly.substack.com/p/ash-weekly-issue-17)

## [Ash AI]+(https://github.com/ash-project/ash_ai) リリース

最近、アプリケーション開発においてAI（LLM）の導入を検討しない開発者はほとんどいないと思います。このような状況で、強力な宣言的フレームワークであるAshにAI向けの拡張機能が追加されるのは当然の流れでした。

Ash AIリポジトリは2024年8月に作成され、そのコンセプトに期待が集まっていましたが、今回のElixirConf EU 2025で正式に発表されました。私も2025年3月から本格的にAsh AIを使い始め、貢献しています（現在#2コントリビューター）。

Ash AIは以下のような機能を提供します。

- **Prompt-backed Actions**: AIを利用して結果を返す汎用的なアクションを簡単に宣言できます。
- **Tool Definition**: 既に宣言したアクションをLLMのツールとして簡単に公開できます。
- **Vectorization**: リソースに対してRAGを簡単に実装できます。
- **MCP Server**: 開発用にアプリケーション情報を提供するMCPサーバーや、本番用に内部アクションをツールとして提供するMCPサーバーを簡単に作成できます。

参考: [Ash AI: A comprehensive LLM toolbox for Ash Framework]+(https://alembic.com.au/blog/ash-ai-comprehensive-llm-toolbox-for-ash-framework)

## [ElixirConf EU 2025]+(https://www.elixirconf.eu/) まとめ

2025年5月14日〜16日にポーランド・クラクフでElixirConf EU 2025が開催されました。

ElixirConfはElixirユーザーにとって最大のイベントで、毎年上半期にEU、下半期にUSで開催されます。最大級のイベントの一つだけに、興味深い内容が多くありました。その中から主要なトピックが今回のニュースレターで共有されています。

### [Code generators are dead, long live code generators - Chris McCord]+(https://www.youtube.com/watch?v=ojL_VHc4gLk)

Chris McCordが所属する[fly.io]+(https://fly.io/)から[Phoniex.new]+(https://phoenix.new/)というリモートコーディングエージェントサービスがリリースされました。
Zach DanielはPhoenix.newをIDE + Cloud + Elixir & Phoenixに特化したコーディングアシスタントと表現しています。

AIの未来についてどう考えるかはさておき、ElixirでもAI関連の面白い試みが出てきていることを非常に前向きに評価しています。
現在はウェイトリスト経由でのみ利用可能なので、興味のある方は申し込んでみてください。

### [Introducing Phoenix.Sync - James Arthur]+(https://www.youtube.com/watch?v=4IWShnVuRCg)

[Phoenix.Sync]+(https://hexdocs.pm/phoenix_sync)はPhoenixに[Electric]+(https://electric-sql.com/)を密接に統合し、リアルタイム同期を簡単に実現するための試みです。

Electricは優れたユーザー体験を提供するローカルファーストアプリケーションが増えている中で、それを実現する方法として注目していましたので、さらに期待が高まります。
LiveViewではなく、Reactやモバイル環境など、Electricが既に構築しているフロントエンド環境と連携できる点で、Phoenixの可能性がさらに広がる良い機会だと思います。

### The AtomVM and New Horizons for Elixir

[AtomVM]+(https://www.atomvm.net/)はBEAMの軽量実装で、IoTデバイスやブラウザでErlang（およびElixir）をサポートすることを目指すプロジェクトです。

ElixirConf EU 2025ではブラウザでの動作によりフォーカスされていたようで、hexdocsのコードブロックをブラウザ上で直接実演することも可能だったようです。
今後、これを基盤にどのような試みが生まれるのか楽しみです。

### Hologram: Building Rich UIs with Elixir Running in the Browser

[Hologram]+(https://hologram.page/)はElixirでフロントエンド／バックエンドの両方を記述することを目指すプロジェクトです。

LiveViewがバックエンドでほとんどを処理し、非常に薄いフロントエンドを志向するのに対し、Hologramは従来のアプリケーションのようにフロントエンドも独自の状態を持つ方向性ですが、それをElixirで簡単に記述できるようにしようとしているようです。
最初にリリースされた際に説明を読んでみましたが、まだコンセプトを完全には理解できていません。この方法でどこまで実装できるのか興味があります。

## プロジェクト紹介

Ash AIは現在、いくつかの機能がOpenAIのモデルのみ利用可能となっています。
これはAIプロバイダーごとにJSONスキーマ仕様が異なるためですが、この問題を解決するために[LangSchema]+(https://github.com/nallwhy/lang_schema)というライブラリを実装しました。
Abstract schemaという概念を設け、それを使ってコードを書くことで、AIプロバイダーのJSONスキーマ仕様に合わせて変換するというコンセプトです。
Ash AIでの利用も[議論中]+(https://github.com/ash-project/ash_ai/issues/24)なので、AI関連のコードを書く際にぜひ使ってみてください。
