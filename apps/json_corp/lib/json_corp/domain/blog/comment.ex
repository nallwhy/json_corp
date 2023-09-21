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

  defmodule Command do
    import Ecto.Changeset
    alias JsonCorp.Blog.Comment

    @required_for_create [:post_slug, :session_id, :name, :email, :body]
    def changeset_for_create(%Comment{} = struct, attrs) do
      struct
      |> cast(attrs, @required_for_create)
      |> validate_required(@required_for_create)
      |> validate_length(:name, max: 255)
      |> validate_length(:email, max: 255)
      |> validate_length(:body, max: 1000)
    end

    def create(attrs) do
      %Comment{}
      |> changeset_for_create(attrs)
    end
  end
end
