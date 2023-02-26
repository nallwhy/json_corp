import Config

# Configures the endpoint
config :test_api, TestApiWeb.Endpoint,
  url: [host: "localhost", path: "/test_api"],
  render_errors: [view: TestApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TestApi.PubSub

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.10",
  test_api: [
    args:
      ~w(../../../deps/test_api/assets/js/app.js --bundle --target=es2017 --outdir=../priv/static/test_api/assets),
    cd: Path.expand("../../apps/json_corp_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../../deps", __DIR__)}
  ]
