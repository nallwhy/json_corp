[
  import_deps: [:ash_ai, :ash, :reactor, :ecto, :phoenix],
  plugins: [Spark.Formatter, Phoenix.LiveView.HTMLFormatter, TailwindFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]
