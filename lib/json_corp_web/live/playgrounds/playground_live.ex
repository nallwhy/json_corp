defmodule JsonCorpWeb.Playgrounds.PlaygroundLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>{gettext("playgrounds") |> String.capitalize()}</.h1>
    <div class="flex flex-wrap gap-6">
      <.card :for={{title, description, path} <- list_playgrounds()} title={title}>
        <p>{description}</p>
        <:actions>
          <.link navigate={path} class="btn btn-primary">Go to {title}</.link>
        </:actions>
      </.card>
    </div>
    """
  end

  defp list_playgrounds() do
    [
      {"Form", "Example of LiveView form binding", ~p"/playgrounds/form"},
      {"Chat", "Example of PubSub with LiveView", ~p"/playgrounds/chat"}
    ]
  end
end
