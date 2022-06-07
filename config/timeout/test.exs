import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :timeout, TimeoutWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "GK13zullVHEL22JG+omf226RW9ys/HZQn08VfNP1IObVergnuhm6tukw39XPWaVh",
  server: false

# In test we don't send emails.
config :timeout, Timeout.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
