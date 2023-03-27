defmodule JsonCorp.Chat.Message do
  @enforce_keys [:user_id, :body, :created_at]
  defstruct @enforce_keys

  def new(%{user_id: user_id, body: body}) do
    %__MODULE__{
      user_id: user_id,
      body: body,
      created_at: DateTime.utc_now()
    }
  end
end
