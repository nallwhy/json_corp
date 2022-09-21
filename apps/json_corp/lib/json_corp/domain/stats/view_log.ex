defmodule JsonCorp.Stats.ViewLog do
  use Ecto.Schema

  schema "view_logs" do
    field :session_id, Ecto.UUID
    field :uri, :string
    field :created_at, :utc_datetime_usec
  end
end
