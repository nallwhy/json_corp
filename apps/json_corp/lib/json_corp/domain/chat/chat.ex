defmodule JsonCorp.Chat do
  alias __MODULE__.{ChatServer, Message}

  def create_channel(channel_name) do
    ChatServer.create_channel(channel_name)
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
  end

  def list_messages(channel_name) do
    ChatServer.list_messages(channel_name)
  end
end
