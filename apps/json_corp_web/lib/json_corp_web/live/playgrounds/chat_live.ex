defmodule JsonCorpWeb.Playgrounds.ChatLive do
  use JsonCorpWeb, :live_view

  @default_channel_name "general"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |> assign(:channel_name, @default_channel_name)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Chat</.h1>
    <div class="flex">
      <.live_component
        module={JsonCorpWeb.Playgrounds.ChatLive.Channel}
        id={@channel_name}
        channel_name={@channel_name}
      />
    </div>
    """
  end
end
