defmodule JsonCorp.Chat.ChatServer do
  use GenServer
  import Ex2ms
  alias JsonCorp.Chat.Message

  @server_name :chat
  @message_limit 100

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def create_channel(channel_name) do
    GenServer.call(__MODULE__, {:create_channel, channel_name})
  end

  def list_channels() do
    query =
      fun do
        {channel_name, _messages} -> channel_name
      end

    {:ok, :ets.select(@server_name, query)}
  end

  def send_message(channel_name, %Message{} = message) do
    GenServer.call(__MODULE__, {:send_message, channel_name, message})
  end

  def list_messages(channel_name) do
    query =
      fun do
        {^channel_name, messages} -> messages
      end

    [messages] = :ets.select(@server_name, query)

    {:ok, messages}
  end

  @impl true
  def init(_) do
    :ets.new(@server_name, [:set, :protected, :named_table, read_concurrency: true])

    {:ok, nil}
  end

  @impl true
  def handle_call({:create_channel, channel_name}, _from, state) do
    :ets.insert(@server_name, {channel_name, []})

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:send_message, channel_name, message}, _from, state) do
    query =
      fun do
        {^channel_name, messages} -> messages
      end

    [messages] = :ets.select(@server_name, query)

    new_messages =
      [message | messages]
      |> Enum.take(@message_limit)

    :ets.insert(@server_name, {channel_name, new_messages})

    {:reply, :ok, state}
  end
end
