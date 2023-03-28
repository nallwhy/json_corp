defmodule JsonCorpWeb.Playgrounds.ChatLive.Channel do
  use JsonCorpWeb, :live_component
  alias JsonCorp.Chat
  alias JsonCorp.Chat.Message

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:message, "")

    {:ok, socket}
  end

  # handle new event message from parent
  @impl true
  def update(%{event_message: {:message_sent, %Message{} = message}}, socket) do
    socket =
      socket
      |> stream_insert(:messages, message)
      |> push_event("message_sent", %{})

    {:ok, socket}
  end

  # init
  @impl true
  def update(assigns, socket) do
    new_channel_name = assigns.channel_name

    if connected?(socket) do
      Chat.subscribe_channel(new_channel_name)
    end

    socket =
      socket
      |> assign(assigns)
      |> assign_messages(new_channel_name)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <p>Your ID: <%= @session_id %></p>
      <.h2><%= @channel_name %></.h2>
      <div id="messages" class="h-96 overflow-y-auto" phx-hook="ChatMessages">
        <div :for={{message_id, message} <- @streams.messages} id={message_id} class="mt-4">
          <p>User id: <%= message.user_id %></p>
          <p><%= message.created_at %></p>
          <p><%= message.body %></p>
        </div>
      </div>
      <.simple_form
        for={%{}}
        phx-change="update_message"
        phx-submit="send_message"
        phx-target={@myself}
        phx-debounce
      >
        <.input type="text" name="message" value={@message} />
        <:actions>
          <.button type="submit" disabled={@message == ""}>Send</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("update_message", %{"message" => message}, socket) do
    socket =
      socket
      |> assign(:message, message)

    {:noreply, socket}
  end

  @impl true
  def handle_event("send_message", %{"message" => message}, socket) do
    Chat.send_message(socket.assigns.channel_name, %{
      user_id: socket.assigns.session_id,
      body: message
    })

    socket =
      socket
      |> assign(:message, "")

    {:noreply, socket}
  end

  defp assign_messages(socket, channel_name) do
    {:ok, messages} = Chat.list_messages(channel_name)

    socket
    |> stream(:messages, messages)
    |> push_event("message_sent", %{})
  end
end
