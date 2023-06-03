defmodule JsonCorpWeb.Playgrounds.ChatLive.Channels do
  use JsonCorpWeb, :live_component
  alias JsonCorp.Chat

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:channel_name, "")

    if connected?(socket) do
      Chat.subscribe_channels()
    end

    {:ok, socket}
  end

  @impl true
  def update(%{event_message: {:channel_created, channel_name}}, socket) do
    socket =
      socket
      |> update(:channels, &(&1 ++ [channel_name]))

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_channels()

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="basis-56 flex flex-col px-4 py-2 rounded-md bg-slate-50">
      <div class="flex-1 overflow-y-auto mt-2">
        <div :for={channel_name <- @channels} class="py-2 hover:bg-slate-200">
          <.link phx-click={JS.push("select_channel", value: %{channel_name: channel_name})}>
            <p># <%= channel_name %></p>
          </.link>
        </div>
      </div>
      <.simple_form
        for={%{}}
        phx-change="update_channel_name"
        phx-submit="create_channel"
        phx-target={@myself}
        phx-debounce
      >
        <.input type="text" name="channel_name" label="New Channel" value={@channel_name} />
        <:actions>
          <.button type="submit" disabled={@channel_name == ""}>Create Channel</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("update_channel_name", %{"channel_name" => channel_name}, socket) do
    socket =
      socket
      |> assign(:channel_name, channel_name)

    {:noreply, socket}
  end

  @impl true
  def handle_event("create_channel", %{"channel_name" => channel_name}, socket) do
    :ok = Chat.create_channel(channel_name)

    socket =
      socket
      |> assign(:channel_name, "")

    {:noreply, socket}
  end

  defp assign_channels(socket) do
    {:ok, channels} = Chat.list_channels()

    socket
    |> assign(:channels, channels)
  end
end
