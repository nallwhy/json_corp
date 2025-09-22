defmodule JsonCorp.MixProject do
  use Mix.Project

  def project do
    [
      app: :json_corp,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: releases(),
      consolidate_protocols: Mix.env() != :dev
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {JsonCorp.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon, :inets]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:tidewave, "~> 0.5", only: [:dev]},
      {:ash_ai, "~> 0.2"},
      {:usage_rules, "~> 0.1", only: [:dev]},
      {:sourceror, "~> 1.8"},
      {:ash, "~> 3.0"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:swoosh, "~> 1.3"},
      {:earmark, "~> 1.4"},
      {:makeup, "~> 1.1"},
      {:makeup_elixir, "~> 1.0"},
      {:nebulex, "~> 2.4"},
      {:decorator, "~> 1.4"},
      {:uuid, "~> 1.1"},
      {:req, "~> 0.3"},
      {:doumi, "~> 0.2.3", only: :test},
      {:ex2ms, "~> 1.0"},
      {:sobelow, "~> 0.12", only: [:dev, :test], runtime: false},
      {:ex_cldr, "~> 2.37"},
      {:ex_cldr_dates_times, "~> 2.14"},
      {:ex_cldr_locale_display, "~> 1.1"},
      {:xml_builder, "~> 2.1"},
      {:sentry, "~> 10.0"},
      # for sentry
      {:hackney, "~> 1.20"},
      {:datix, "~> 0.3"},
      {:mdex, "~> 0.7.0"},
      {:lens2, "~> 0.2.1"},
      {:phoenix, "~> 1.7.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_live_view, "~> 1.0", override: true},
      {:phoenix_view, "~> 2.0"},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.8.1"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:plug_cowboy, "~> 2.5"},
      # {:test_api, github: "nallwhy/test_api", tag: "v0.5"},
      {:tailwind, "~> 0.3.0", runtime: Mix.env() == :dev},
      {:doumi_phoenix_svg, "~> 0.1"},
      {:ecto_psql_extras, "~> 0.6"},
      {:plug_canonical_host, "~> 2.0"},
      {:bandit, "~> 1.0"},
      {:doumi_phoenix_params, "~> 0.3.4"},
      {:sitemapper, "~> 0.7"},
      {:ex_cldr_plugs, "~> 1.3"},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:fluxon, "~> 1.1.0", repo: :fluxon},
      {:tailwind_formatter, "~> 0.4.2"},
      {:igniter, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop --force-drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.build": [
        "cmd npm install --prefix assets",
        "tailwind default --minify",
        "esbuild default --minify",
        # "esbuild test_api --minify",
        "phx.digest"
      ],
      "release.setup": ["assets.build", "gen.sitemap", "gen.rss"]
    ]
  end

  defp releases do
    [
      json_corp_app: [
        applications: [
          json_corp: :permanent
        ]
      ]
    ]
  end
end
