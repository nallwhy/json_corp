defmodule JsonCorpWeb.Playgrounds.ChatLive do
  use JsonCorpWeb, :live_view

  @code_url "https://github.com/nallwhy/json_corp/blob/main/apps/json_corp_web/lib/json_corp_web/live/playgrounds/chat_live.ex"
  @default_channel_name "general"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:code_url, @code_url)

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
    <.link href={@code_url} class="underline" target="_blank">Open Code</.link>
    <div class="flex h-[32rem] gap-x-4">
      <.live_component module={JsonCorpWeb.Playgrounds.ChatLive.Channels} id="channels" />
      <.live_component
        module={JsonCorpWeb.Playgrounds.ChatLive.Channel}
        id="channel"
        channel_name={@channel_name}
        user={%{id: @session_id, name: @session_id}}
      />
    </div>
    """
  end

  @impl true
  def handle_event("select_channel", %{"channel_name" => channel_name}, socket) do
    socket =
      socket
      |> assign(:channel_name, channel_name)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:channel_created, channel_name} = message, socket) do
    send_update(JsonCorpWeb.Playgrounds.ChatLive.Channels,
      id: "channels",
      event_message: message
    )

    socket =
      socket
      |> assign(:channel_name, channel_name)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:message_sent, _} = message, socket) do
    send_update(JsonCorpWeb.Playgrounds.ChatLive.Channel,
      id: "channel",
      channel_name: socket.assigns.channel_name,
      event_message: message
    )

    {:noreply, socket}
  end
end
