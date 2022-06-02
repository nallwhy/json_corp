defmodule JsonCorp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # JsonCorp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: JsonCorp.PubSub}
      # Start a worker by calling: JsonCorp.Worker.start_link(arg)
      # {JsonCorp.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: JsonCorp.Supervisor)
  end
end
