defmodule JsonCorpWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :json_corp_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {JsonCorpWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.7.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_live_view, "~> 1.0", override: true},
      {:phoenix_view, "~> 2.0"},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.8.1"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:json_corp, in_umbrella: true},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      # {:test_api, github: "nallwhy/test_api", tag: "v0.5"},
      {:tailwind, "~> 0.1.8", runtime: Mix.env() == :dev},
      {:doumi_phoenix_svg, "~> 0.1"},
      {:uuid, "~> 1.1"},
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
       depth: 1}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "cmd npm install --prefix assets",
        "tailwind default --minify",
        "esbuild default --minify",
        # "esbuild test_api --minify",
        "phx.digest"
      ],
      "release.setup": ["assets.deploy", "gen.sitemap", "gen.rss"]
    ]
  end
end
