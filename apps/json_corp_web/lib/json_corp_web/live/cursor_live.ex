defmodule JsonCorpWeb.CursorLive do
  use JsonCorpWeb, :live_view
  alias JsonCorpWeb.Presence
  alias JsonCorp.PubSub

  on_mount(JsonCorpWeb.SessionHook)

  @presence_topic "cursor"

  @impl true
  def mount(_params, _session, socket) do
    position = %{x: nil, y: nil, base_x: nil, base_y: nil}
    user = %{id: socket.assigns.session_id, name: socket.assigns.session_id}

    if connected?(socket) do
      {:ok, _} =
        Presence.track(self(), @presence_topic, user.id, %{
          name: user.name,
          position: position
        })

      Phoenix.PubSub.subscribe(PubSub, @presence_topic)
    end

    presences = Presence.list(@presence_topic)
    users = presences |> convert_presences_to_users(user.id)

    socket =
      socket
      |> assign(:presences, presences)
      |> assign(:user, user)
      |> assign(:users, users)

    {:ok, socket, layout: false}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="cursor-container" phx-hook="Cursor">
      <ul :for={{user_id, user} <- @users} class="list-none">
        <li
          :if={user.position.x != nil}
          style={"color: deeppink; left: #{user.position.x + user.position.base_x}px; top: #{user.position.y + user.position.base_y}px"}
          class="flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden"
        >
          <Icon.cursor />
          <span
            style="background-color: deeppink;"
            class="mt-0 ml-2 px-2 py-1 text-sm rounded-md text-white"
          >
            <%= user_id %>
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
    Presence.update(self(), @presence_topic, socket.assigns.session_id, fn meta ->
      meta |> Map.put(:position, %{x: x, y: y, base_x: base_x, base_y: base_y})
    end)

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
    presences = Presence.sync_presence_diff(socket.assigns.presences, payload)
    users = presences |> convert_presences_to_users(socket.assigns.user.id)

    socket =
      socket
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
    %{position: last_meta.position}
  end
end
