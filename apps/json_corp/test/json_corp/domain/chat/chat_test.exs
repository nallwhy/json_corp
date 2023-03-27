defmodule JsonCorp.ChatTest do
  use ExUnit.Case
  alias JsonCorp.Chat.ChatServer
  alias JsonCorp.Chat

  @message_params %{user_id: 1, body: "hello"}

  setup do
    ChatServer.reset()

    :ok
  end

  describe "create_channel/1" do
    test "returns :ok with valid channel_name" do
      assert Chat.create_channel("general") == :ok
    end

    test "returns :ok and do nothing with duplicate channel_name" do
      Chat.create_channel("general")

      Chat.send_message("general", @message_params)

      assert {:ok, [_ | _]} = Chat.list_messages("general")

      assert Chat.create_channel("general") == :ok
      assert {:ok, [_ | _]} = Chat.list_messages("general")
    end
  end

  describe "delete_channel/1" do
    test "returns :ok with valid channel_name" do
      Chat.create_channel("general")

      assert Chat.delete_channel("general") == :ok
      assert Chat.list_channels() == {:ok, []}
    end

    test "returns :ok and do nothing with invalid channel_name" do
      assert Chat.delete_channel("general") == :ok
    end
  end

  describe "list_channels/0" do
    test "returns channels" do
      Chat.create_channel("general")
      Chat.create_channel("random")
      Chat.create_channel("general")
      Chat.create_channel("chat")

      assert {:ok, ["chat", "general", "random"]} = Chat.list_channels()
    end
  end

  describe "send_message/2" do
    test "returns :ok with valid params" do
      Chat.create_channel("general")

      assert :ok = Chat.send_message("general", @message_params)
    end

    test "returns :error with invalid params" do
      assert {:error, :invalid_channel} =
               Chat.send_message("not_created_channel", @message_params)
    end
  end

  describe "list_messages/1" do
    test "returns messages" do
      Chat.create_channel("general")

      Chat.send_message("general", %{@message_params | body: "hello"})
      Chat.send_message("general", %{@message_params | body: "hi"})

      assert {:ok, [fetched_message0, fetched_message1]} = Chat.list_messages("general")
      assert fetched_message0.user_id == @message_params.user_id
      assert fetched_message0.body == "hello"
      assert fetched_message1.user_id == @message_params.user_id
      assert fetched_message1.body == "hi"
    end
  end
end
