defmodule JsonCorpWeb.Playgrounds.ChatLive.Channel do
  use JsonCorpWeb, :live_component
  alias JsonCorp.Chat
  alias JsonCorp.Chat.Message

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  # handle new event message from parent
  @impl true
  def update(%{event_message: {:message_sent, %Message{} = message}}, socket) do
    socket =
      socket
      |> stream_insert(:messages, message)

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
      <.h2><%= @channel_name %></.h2>
      <div>
        <div :for={{message_id, message} <- @streams.messages} id={message_id} class="mt-4">
          <p>User id: <%= message.user_id %></p>
          <p><%= message.created_at %></p>
          <p><%= message.body %></p>
        </div>
      </div>
    </div>
    """
  end

  def assign_messages(socket, channel_name) do
    {:ok, messages} = Chat.list_messages(channel_name)

    socket |> stream(:messages, messages)
  end
end
