defmodule JsonCorp.Blog.Comment do
  use JsonCorp.Schema

  schema "comments" do
    field :post_slug, :string
    field :session_id, Ecto.UUID
    field :name, :string
    field :email, :string
    field :body, :string
    field :confirmed_at, :utc_datetime_usec
    field :deleted_at, :utc_datetime_usec

    timestamps()
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

    @required_for_delete [:deleted_at]
    def changeset_for_delete(%Comment{} = struct, attrs) do
      struct
      |> cast(attrs, [:deleted_at])
      |> validate_required([:deleted_at])
    end

    def create(attrs) do
      %Comment{}
      |> changeset_for_create(attrs)
    end

    def delete(%Comment{} = comment) do
      comment
      |> changeset_for_delete(%{deleted_at: DateTime.utc_now()})
    end
  end

  defmodule Query do
    import Ecto.Query
    alias JsonCorp.Blog.Comment

    def list_by_post_slug(post_slug) do
      Comment
      |> where([c], c.post_slug == ^post_slug)
      |> where([c], is_nil(c.deleted_at))
      |> order_by([c], asc: c.inserted_at)
    end

    def get(id) do
      Comment
      |> where([c], c.id == ^id)
    end
  end
end
