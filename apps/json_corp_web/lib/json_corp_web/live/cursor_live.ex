defmodule JsonCorpWeb.CursorLive do
  use JsonCorpWeb, :live_view
  alias JsonCorpWeb.Presence
  alias JsonCorp.PubSub

  on_mount(JsonCorpWeb.SessionHook)

  @presence_topic_prefix "cursor:"

  @impl true
  def mount(_params, _session, socket) do
    user = %{id: socket.assigns.session_id, name: socket.assigns.session_id}

    if connected?(socket) do
      {:ok, _} = Registry.register(Registry.WSConnRegistry, socket.assigns.ws_conn_id, nil)
    end

    socket =
      socket
      |> assign(:user, user)
      |> assign(:users, [])

    {:ok, socket, layout: false}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="cursor-container" phx-hook="Cursor">
      <ul :for={{ws_conn_id, user} <- @users} class="list-none">
        <% color = generate_hsl(ws_conn_id) %>
        <li
          :if={user.position != nil}
          style={"color: #{color}; left: #{user.position.x + user.position.base_x}px; top: #{user.position.y + user.position.base_y}px"}
          class="flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden"
        >
          <Icon.cursor />
          <span
            style={"background-color: #{color};"}
            class="mt-0 ml-2 px-2 py-1 text-sm rounded-md text-white"
          >
            <%= user.name %>
          </span>
        </li>
      </ul>
    </div>
    """
  end

  @impl true
  def handle_event(
        "cursor-move",
        %{"x" => x, "y" => y, "base_x" => base_x, "base_y" => base_y},
        socket
      ) do
    Presence.update(
      self(),
      @presence_topic_prefix <> socket.assigns.path,
      socket.assigns.ws_conn_id,
      fn meta ->
        meta |> Map.put(:position, %{x: x, y: y, base_x: base_x, base_y: base_y})
      end
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{
          topic: _topic,
          event: "presence_diff",
          payload: payload
        },
        socket
      ) do
    presences = Presence.sync_presence_diff(socket.assigns.presences, payload)
    users = presences |> convert_presences_to_users(socket.assigns.ws_conn_id)

    socket =
      socket
      |> assign(:presences, presences)
      |> assign(:users, users)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:uri_changed, uri}, socket) do
    user = socket.assigns.user
    %{path: path} = URI.parse(uri)
    presence_topic = @presence_topic_prefix <> path

    if old_path = socket.assigns[:path] do
      old_presence_topic = @presence_topic_prefix <> old_path

      Presence.untrack(self(), old_presence_topic, socket.assigns.ws_conn_id)

      :ok = Phoenix.PubSub.unsubscribe(PubSub, old_presence_topic)
    end

    if connected?(socket) do
      {:ok, _} =
        Presence.track(self(), presence_topic, socket.assigns.ws_conn_id, %{
          id: user.id,
          name: user.name,
          position: nil
        })

      :ok = Phoenix.PubSub.subscribe(PubSub, presence_topic)
    end

    presences = Presence.list(presence_topic)
    users = presences |> convert_presences_to_users(socket.assigns.ws_conn_id)

    socket =
      socket
      |> assign(:path, path)
      |> assign(:presences, presences)
      |> assign(:users, users)

    {:noreply, socket}
  end

  defp convert_presences_to_users(presences, my_user_id) do
    presences
    |> Map.new(fn {user_id, presence} -> {user_id, convert_presence_to_user(presence)} end)
    |> Map.delete(my_user_id)
  end

  defp convert_presence_to_user(nil) do
    nil
  end

  defp convert_presence_to_user(%{metas: [last_meta | _]}) do
    %{name: last_meta.name, position: last_meta.position}
  end

  def generate_hsl(str) do
    hue = to_charlist(str) |> Enum.sum() |> rem(360)
    "hsl(#{hue}, 70%, 40%)"
  end
end
