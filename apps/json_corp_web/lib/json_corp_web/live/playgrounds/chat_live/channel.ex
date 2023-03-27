defmodule JsonCorpWeb.Playgrounds.ChatLive.Channel do
  use JsonCorpWeb, :live_component
  alias JsonCorp.Chat

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_messages(assigns.channel_name)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.h2><%= @channel_name %></.h2>
      <div>
        <div :for={message <- @messages}>
          <p><%= message.body %></p>
        </div>
      </div>
    </div>
    """
  end

  def assign_messages(socket, channel_name) do
    {:ok, messages} = Chat.list_messages(channel_name)

    socket |> assign(:messages, messages)
  end
end
