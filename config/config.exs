# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :ash,
  allow_forbidden_field_for_relationships_by_default?: true,
  include_embedded_source_by_default?: false,
  show_keysets_for_all_actions?: false,
  default_page_type: :keyset,
  policies: [no_filter_static_forbidden_reads?: false],
  keep_read_action_loads_when_loading?: false,
  default_actions_require_atomic?: true,
  read_action_after_action_hooks_in_order?: true,
  bulk_actions_default_to_errors?: true

config :spark,
  formatter: [
    remove_parens?: true,
    "Ash.Resource": [
      section_order: [
        :resource,
        :code_interface,
        :actions,
        :policies,
        :pub_sub,
        :preparations,
        :changes,
        :validations,
        :multitenancy,
        :attributes,
        :relationships,
        :calculations,
        :aggregates,
        :identities
      ]
    ],
    "Ash.Domain": [section_order: [:resources, :policies, :authorization, :domain, :execution]]
  ]

# Configure Mix tasks and generators
config :json_corp,
  ecto_repos: [JsonCorp.Repo]

config :json_corp, JsonCorp.Repo, migration_timestamps: [type: :timestamptz]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :json_corp, JsonCorp.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :json_corp,
  ecto_repos: [JsonCorp.Repo],
  generators: [context_app: :json_corp]

# Configures the endpoint
config :json_corp, JsonCorpWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  render_errors: [
    formats: [html: JsonCorpWeb.ErrorHTML, json: JsonCorpWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: JsonCorp.PubSub,
  live_view: [signing_salt: "O1MGp8KB"],
  adapter: Bandit.PhoenixAdapter

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.24.2",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "4.1.8",
  default: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :json_corp, JsonCorp.Core.Cache.Local, stats: true

config :json_corp, :slack, webhook_url: ""

config :ex_cldr,
  default_backend: JsonCorp.Core.Cldr

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# import_config "./test_api/config.exs"
