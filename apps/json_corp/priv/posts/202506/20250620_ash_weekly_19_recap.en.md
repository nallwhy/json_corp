%{
title: "Ash Weekly: Issue #19 Recap",
description: "Ash homepage/doc revamped, AshAdmin file upload, AshAI non-OpenAI LLM, UsageRules --sync-to-folder flag, Reactor doc revamped, New Ash extensions.",
category: :dev,
cover_url: "/images/blog/20250621_ash_weekly_19_recap_cover_en.png",
tags: ["Ash", "Ash Weekly", "AshAdmin", "UsageRules", "Reactor", "Elixir"]
}

---

[Ash]+(https://ash-hq.org/) is currently the hottest and fast-becoming standard declarative framework in Elixir. [Ash Weekly]+(https://ashweekly.substack.com/) delivers weekly updates on what's happening in the Ash ecosystem, and here is a summary.

Original: [Ash Weekly: Issue #19]+(https://ashweekly.substack.com/p/ash-weekly-issue-19)

## Homepage & What is Ash Guide Revamped

Since Ash is not a framework concept that typically exists in other languages, people usually need additional explanation to understand its concepts.

However, the existing explanations on the homepage and documentation were somewhat lacking. This time, the [Ash homepage]+(https://ash-hq.org/) and the [What is Ash?]+(https://hexdocs.pm/ash/what-is-ash.html) section of the documentation have been updated, making them much easier to understand.

If you still don't understand Ash well, be sure to check it out!

## AshAdmin File Upload Support

[AshAdmin]+(https://github.com/ash-project/ash_admin) is a library that automatically generates admin pages from Ash declarations.

Previously, file uploads were not possible here. This time, it has been updated to automatically support file uploads for `:file` type arguments. (Many of these Ash ecosystem developments are coming from community members. 👍)

The design isn't very pretty yet, but hopefully this can be improved too.

## Support for Non-OpenAI Models in prompt-backed actions

The prompt-backed actions in [AshAI]+(https://github.com/ash-project/ash_ai), which makes AI-related work easier based on Ash, allow actions to be performed through LLMs.

Here's an example from the AshAI README.md for understanding:

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

Previously, only OpenAI models were available, but with support for various adapters that enable connections with LLMs of different characteristics, various provider LLM models are now usable.

## UsageRules --sync-to-folder flag

[UsageRules]+(https://github.com/ash-project/usage_rules) is a project that collects `usage-rules.md` files from each library, making them available as context for LLMs.

A `--sync-to-folder` flag has been added this time, allowing you to use a format that links to each file instead of putting all content in one file.

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

This way, since you're not putting all content into the context, token usage is reduced, but it might take more time to find and explore the necessary files. You can apply it according to your preferred direction.

## Reactor documentation overhaul

[Reactor]+(https://github.com/ash-project/reactor) is a library that makes it easy to use the [Saga pattern]+(https://learn.microsoft.com/en-us/azure/architecture/patterns/saga). The Saga pattern is great for implementing distributed transactions.

The [documentation]+(https://hexdocs.pm/reactor/readme.html) has been revamped this time, so if you're interested in using the Saga pattern, it would be good to take a look.

## Contributor Names in Changelogs

Contributors to Ash projects will have their names mentioned in release notes. This shows their commitment to building the community.

## Community Extensions

### [AshNeo4j]+(https://github.com/diffo-dev/ash_neo4j)

A library that supports [Neo4j]+(https://neo4j.com/), a representative Graph Database, for Ash.

### [AshOutstanding]+(https://github.com/diffo-dev/ash_outstanding)

A library that supports the [Outstanding]+(https://github.com/diffo-dev/outstanding) protocol for Ash.

The Outstanding protocol seems to make it easy to know whether expected values are currently satisfied, and if not, which parts are not satisfied.

### [AshCommanded]+(https://github.com/accountex-org/ash_commanded)

A library that supports [Commanded]+(https://github.com/commanded/commanded), which makes it easy to apply CQRS/ES patterns to Ash.

The CQRS/ES pattern has always remained something I want to try but haven't applied yet. With the recently announced [AshEvents]+(https://github.com/ash-project/ash_events) also available, I should give it a try.

## LLMs & Elixir: Windfall or Deathblow

Recently, [LLMs & Elixir: Windfall or Deathblow]+(https://www.zachdaniel.dev/p/llms-and-elixir-windfall-or-deathblow?utm_source=substack&utm_campaign=post_embed&utm_medium=web) written by Zach Daniel became a hot topic on Hacker News.

This content connects with the direction of recent work in Elixir like [Tidewave]+(https://tidewave.ai/), [Phoenix.new](https://phoenix.new/), and [UsageRules]+(https://github.com/ash-project/usage_rules) that makes AI-assisted coding easier.
