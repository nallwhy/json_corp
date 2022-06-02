import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :json_corp, JsonCorp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "json_corp_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :json_corp_web, JsonCorpWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "7cPg5FxtvNSnCEJMjE9lSLF1ncmUBuw17RSHNyLWCHk15i2ZdJ4HXR2UZ3IqRdV6",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :json_corp, JsonCorp.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
