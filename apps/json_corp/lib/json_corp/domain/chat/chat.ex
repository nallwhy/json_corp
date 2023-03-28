defmodule JsonCorp.Chat do
  alias __MODULE__.{ChatServer, Message}

  def create_channel(channel_name) do
    ChatServer.create_channel(channel_name)

    broadcast_channels({:channel_created, channel_name})

    :ok
  end

  def delete_channel(channel_name) do
    ChatServer.delete_channel(channel_name)
  end

  def list_channels() do
    ChatServer.list_channels()
  end

  def send_message(channel_name, message_params) do
    message = Message.new(message_params)

    ChatServer.send_message(channel_name, message)

    broadcast_channel(channel_name, {:message_sent, message})

    :ok
  end

  def list_messages(channel_name) do
    ChatServer.list_messages(channel_name)
  end

  def subscribe_channels() do
    Phoenix.PubSub.subscribe(JsonCorp.PubSub, "chat")
  end

  def subscribe_channel(channel_name) do
    Phoenix.PubSub.subscribe(JsonCorp.PubSub, "chat:#{channel_name}")
  end

  defp broadcast_channels(message) do
    Phoenix.PubSub.broadcast(JsonCorp.PubSub, "chat", message)
  end

  defp broadcast_channel(channel_name, message) do
    Phoenix.PubSub.broadcast(JsonCorp.PubSub, "chat:#{channel_name}", message)
  end
end
