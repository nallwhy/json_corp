defmodule JsonCorp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        JsonCorp.Core.Cache.Local,
        # Start the Ecto repository
        JsonCorp.Repo,
        # Start the PubSub system
        {Phoenix.PubSub, name: JsonCorp.PubSub},
        JsonCorpWeb.Telemetry,
        JsonCorpWeb.Endpoint,
        JsonCorpWeb.Presence,
        {Registry, [keys: :unique, name: Registry.WSConnRegistry]},
        JsonCorp.Chat.ChatServer
      ] ++ not_test_children() ++ prod_children()

    Supervisor.start_link(children, strategy: :one_for_one, name: JsonCorp.Supervisor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JsonCorpWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  if Mix.env() != :test do
    # defp not_test_children, do: [JsonCorp.Worker.BlogSearchIndexer]
    defp not_test_children, do: []
  else
    defp not_test_children, do: []
  end

  if Mix.env() == :prod do
    defp prod_children, do: []
  else
    defp prod_children, do: []
  end
end
