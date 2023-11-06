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
        JsonCorp.Chat.ChatServer
      ] ++ not_test_children() ++ prod_children()

    Supervisor.start_link(children, strategy: :one_for_one, name: JsonCorp.Supervisor)
  end

  if Mix.env() != :test do
    defp not_test_children, do: [JsonCorp.Worker.BlogSearchIndexer]
  else
    defp not_test_children, do: []
  end

  if Mix.env() == :prod do
    defp prod_children, do: []
  else
    defp prod_children, do: []
  end
end
