defmodule JsonCorpWeb.Playgrounds.PlaygroundLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Playgrounds</.h1>
    <div class="flex flex-wrap gap-6">
      <.playground_card
        :for={{name, description, path} <- list_playgrounds()}
        name={name}
        description={description}
        path={path}
      >
      </.playground_card>
    </div>
    """
  end

  defp playground_card(assigns) do
    ~H"""
    <div class="card w-96 mx-4 bg-base-100 shadow-xl">
      <div class="card-body">
        <h2 class="card-title"><%= @name %></h2>
        <p><%= @description %></p>
        <div class="card-actions justify-end mt-4">
          <.link navigate={@path} class="btn btn-primary">Go to <%= @name %></.link>
        </div>
      </div>
    </div>
    """
  end

  defp list_playgrounds() do
    [
      {"Form", "Example of LiveView form binding", ~p"/playgrounds/form"}
    ]
  end
end
