%{
title: "Ash Weekly: Issue #17 Recap",
description: "Ash AI, ElixirConf EU 2025, Phoenix.new, Phoenix.Sync, AtomVM, Hologram, LangSchema.",
category: :dev,
cover_url: "/images/blog/20250526_ash_weekly_17_recap_cover_en.png",
tags: ["Ash", "Ash Weekly", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/) Ash is currently the hottest and rapidly becoming the standard declarative framework in Elixir. [Ash Weekly]+(https://ashweekly.substack.com/) is a newsletter that keeps you up to date on everything happening in the Ash ecosystem, and here’s a summary of the latest issue.

Original article: [Ash Weekly: Issue #17]+(https://ashweekly.substack.com/p/ash-weekly-issue-17)

## [Ash AI]+(https://github.com/ash-project/ash_ai) Released

These days, it’s rare to find developers who aren’t considering integrating AI (LLM) into their applications. In this context, it was only natural that a powerful declarative framework like Ash would get an AI extension.

The Ash AI repo was created in August 2024 and quickly drew a lot of attention with its concept. It was officially announced at ElixirConf EU 2025. I’ve been actively using and contributing to Ash AI since March 2025 (currently I'm the #2 contributor).

Ash AI offers the following features:
- **Prompt-backed Actions**: Easily declare generic actions that return results via AI.
- **Tool Definition**: Expose already declared actions as LLM tools with minimal effort.
- **Vectorization**: Easily implement RAG (Retrieval-Augmented Generation) on your resources.
- **MCP Server**: Quickly set up a development MCP server to provide app information, or a production MCP server to expose internal actions as tools.

Reference: [Ash AI: A comprehensive LLM toolbox for Ash Framework]+(https://alembic.com.au/blog/ash-ai-comprehensive-llm-toolbox-for-ash-framework)

## [ElixirConf EU 2025]+(https://www.elixirconf.eu/) Wrap up

ElixirConf EU 2025 took place in Kraków, Poland, from May 14–16.

ElixirConf is the largest event for Elixir enthusiasts—held twice a year, with the EU edition in the first half and the US in the second half. As one of the biggest gatherings in the community, it featured a lot of interesting content, some of which is highlighted in this newsletter.

### [Code generators are dead, long live code generators - Chris McCord]+(https://www.youtube.com/watch?v=ojL_VHc4gLk)

Chris McCord and the team at [fly.io]+(https://fly.io/) introduced [Phoniex.new]+(https://phoenix.new/), a remote coding agent service.
Zach Daniel described Phoenix.new as an IDE + Cloud + Elixir & Phoenix-focused coding assistant.

Regardless of how you feel about the future of AI, it’s great to see these kinds of innovative attempts within the Elixir ecosystem as well. It’s currently available via waitlist, so if you’re interested, sign up!

### [Introducing Phoenix.Sync - James Arthur]+(https://www.youtube.com/watch?v=4IWShnVuRCg)

[Phoenix.Sync]+(https://hexdocs.pm/phoenix_sync) is an effort to tightly integrate [Electric]+(https://electric-sql.com/) with Phoenix, making real-time sync easy to implement.

With the growing trend toward local-first applications for better user experience, Electric is a solution that’s been getting a lot of attention, so this integration is especially exciting.
Unlike LiveView, Phoenix.Sync is designed to work with React, mobile, and other front-end environments where Electric already shines, potentially broadening Phoenix’s reach.

### The AtomVM and New Horizons for Elixir

[AtomVM]+(https://www.atomvm.net/) is a lightweight implementation of the BEAM, aiming to bring Erlang (and Elixir) to IoT devices and browsers.

This year’s ElixirConf EU seemed to focus more on running AtomVM in browsers, with demos like running code blocks from Hexdocs directly in-browser. I’m excited to see what new possibilities will arise from this.

### Hologram: Building Rich UIs with Elixir Running in the Browser

[Hologram]+(https://hologram.page/) is a project aiming to let you write both front-end and back-end in Elixir.

Whereas LiveView handles almost everything on the back-end and keeps the front-end thin, Hologram takes a different approach—allowing you to build front-ends with their own state, but all in Elixir. I haven’t fully wrapped my head around the concept yet, but I’m curious to see how far this approach can go.

## Project Spotlight - [LangSchema]+(https://github.com/nallwhy/lang_schema)

Currently, Ash AI supports only OpenAI models. This is because each AI provider’s JSON schema spec is different. To solve this, I’ve developed a library called [LangSchema]+(https://github.com/nallwhy/lang_schema).
By introducing the concept of an abstract schema, you can write your code once and have it converted to the JSON schema required by each AI provider.
If you’re working with AI, you might want to give it a try.
