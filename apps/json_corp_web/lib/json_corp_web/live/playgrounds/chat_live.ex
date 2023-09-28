defmodule JsonCorpWeb.Playgrounds.ChatLive do
  use JsonCorpWeb, :live_view
  alias JsonCorpWeb.Presence
  alias JsonCorp.PubSub

  @code_url "https://github.com/nallwhy/json_corp/blob/main/apps/json_corp_web/lib/json_corp_web/live/playgrounds/chat_live.ex"
  @default_channel_name "general"

  @presence_topic "chat_presence"

  @impl true
  def mount(_params, _session, socket) do
    user = %{id: socket.assigns.session_id, name: socket.assigns.session_id}

    if connected?(socket) do
      {:ok, _} =
        Presence.track(self(), @presence_topic, user.id, %{
          name: user.name,
          channel: @default_channel_name
        })

      Phoenix.PubSub.subscribe(PubSub, @presence_topic)
    end

    presences = Presence.list(@presence_topic)

    socket =
      socket
      |> assign(:code_url, @code_url)
      |> assign(:user, user)
      |> assign(:presences, presences)
      |> assign(:page_meta, %{title: "Chat in Elixir"})

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
    <p class="my-4">Your ID: <%= @user.id %></p>
    <div class="flex flex-col md:flex-row md:h-[36rem] mt-4 space-y-2 md:space-y-0 md:space-x-4">
      <.live_component module={JsonCorpWeb.Playgrounds.ChatLive.Channels} id="channels" />
      <.live_component
        module={JsonCorpWeb.Playgrounds.ChatLive.Channel}
        id="channel"
        channel_name={@channel_name}
        user={@user}
      />
    </div>
    <div class="mt-2">
      <.live_component
        module={JsonCorpWeb.Playgrounds.ChatLive.Users}
        id="users"
        user={@user}
        presences={@presences}
      />
    </div>
    """
  end

  @impl true
  def handle_event("select_channel", %{"channel_name" => channel_name}, socket) do
    socket =
      socket
      |> change_channel(channel_name)

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
      |> change_channel(channel_name)

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

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{
          topic: @presence_topic,
          event: "presence_diff",
          payload: payload
        },
        socket
      ) do
    socket =
      socket
      |> assign(:presences, Presence.sync_presence_diff(socket.assigns.presences, payload))

    {:noreply, socket}
  end

  defp change_channel(socket, channel_name) do
    Presence.update(self(), @presence_topic, socket.assigns.user.id, fn meta ->
      meta |> Map.put(:channel, channel_name)
    end)

    socket
    |> assign(:channel_name, channel_name)
  end
end
