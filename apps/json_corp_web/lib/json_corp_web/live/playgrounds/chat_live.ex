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
      <.live_component module={JsonCorpWeb.Playgrounds.ChatLive.Channels} id="channels" />
      <.live_component
        module={JsonCorpWeb.Playgrounds.ChatLive.Channel}
        id={@channel_name}
        channel_name={@channel_name}
        session_id={@session_id}
      />
    </div>
    """
  end

  @impl true
  def handle_info({:channel_created, _} = message, socket) do
    send_update(JsonCorpWeb.Playgrounds.ChatLive.Channels,
      id: "channels",
      event_message: message
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:message_sent, _} = message, socket) do
    send_update(JsonCorpWeb.Playgrounds.ChatLive.Channel,
      id: socket.assigns.channel_name,
      channel_name: socket.assigns.channel_name,
      event_message: message
    )

    {:noreply, socket}
  end
end
