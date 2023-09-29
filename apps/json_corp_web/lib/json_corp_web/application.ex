defmodule JsonCorpWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      JsonCorpWeb.Telemetry,
      # Start the Endpoint (http/https)
      JsonCorpWeb.Endpoint,
      # Start a worker by calling: JsonCorpWeb.Worker.start_link(arg)
      # {JsonCorpWeb.Worker, arg},
      JsonCorpWeb.Presence,
      {Registry, [keys: :unique, name: Registry.WSConnRegistry]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JsonCorpWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JsonCorpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
