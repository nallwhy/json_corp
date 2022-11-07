defmodule JsonCorp.Blog.SecretPost do
  use JsonCorp.Schema

  schema "secret_posts" do
    field :title, :string
    field :description, :string
    field :category, :string
    field :slug, :string
    field :body, :string
    field :date_created, :date
    field :cover_url, :string
    field :password, :string

    timestamps()
  end
end
