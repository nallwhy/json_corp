defmodule JsonCorp.Blog.Comment do
  use JsonCorp.Schema

  schema "comments" do
    field :post_slug, :string
    field :session_id, Ecto.UUID
    field :name, :string
    field :email, :string
    field :body, :string
    field :confirmed_at, :utc_datetime_usec
  end
end
