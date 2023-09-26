defmodule JsonCorpWeb.Playgrounds.ChatLive do
  use JsonCorpWeb, :live_view
  alias JsonCorpWeb.Presence
  alias JsonCorp.PubSub

  @code_url "https://github.com/nallwhy/json_corp/blob/main/apps/json_corp_web/lib/json_corp_web/live/playgrounds/chat_live.ex"
  @default_channel_name "general"

  @presence_topic "chat"

  @impl true
  def mount(_params, _session, socket) do
    user = %{id: socket.assigns.session_id, name: socket.assigns.session_id}

    if connected?(socket) do
      {:ok, _} =
        Presence.track(self(), @presence_topic, user.id, %{name: user.name})

      Phoenix.PubSub.subscribe(PubSub, @presence_topic)
    end

    presences = Presence.list(@presence_topic)

    socket =
      socket
      |> assign(:code_url, @code_url)
      |> assign(:user, user)
      |> assign(:presences, presences)

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
    <div class="flex h-[32rem] mt-4 gap-x-4">
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
      |> sync_presence_diff(payload)

    {:noreply, socket}
  end

  defp sync_presence_diff(socket, %{joins: joins, leaves: leaves}) do
    presences = socket.assigns.presences

    presences =
      joins
      |> Enum.reduce(presences, fn {key, %{metas: metas}}, presences ->
        metas
        |> Enum.reduce(presences, fn %{phx_ref: phx_ref} = meta, presences ->
          presences
          |> Map.update(key, %{metas: [meta]}, fn %{metas: old_metas} ->
            case Enum.find_index(old_metas, &(&1.phx_ref == phx_ref)) do
              nil -> %{metas: [meta | old_metas]}
              index -> %{metas: old_metas |> List.replace_at(index, meta)}
            end
          end)
        end)
      end)

    presences =
      leaves
      |> Enum.reduce(presences, fn {key, %{metas: metas}}, presences ->
        metas
        |> Enum.reduce(presences, fn %{phx_ref: phx_ref}, presences ->
          presences
          |> Map.update(key, %{metas: []}, fn %{metas: old_metas} ->
            case Enum.find_index(old_metas, &(&1.phx_ref == phx_ref)) do
              nil -> %{metas: old_metas}
              index -> %{metas: old_metas |> List.delete_at(index)}
            end
          end)
        end)
      end)

    socket
    |> assign(:presences, presences)
  end
end
