[
  import_deps: [:ecto, :phoenix],
  plugins: [
    Phoenix.LiveView.HTMLFormatter,
    TailwindFormatter
  ],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]
