[
  import_deps: [:ecto, :phoenix],
  plugins: [
    Phoenix.LiveView.HTMLFormatter,
    Spark.Formatter,
    TailwindFormatter
  ],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]
