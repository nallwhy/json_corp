defmodule JsonCorp.Blog.Post do
  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          category: String.t(),
          slug: String.t(),
          body: String.t(),
          date_created: Date.t(),
          cover_url: String.t()
        }

  @enforce_keys [:title, :description, :category, :slug, :body, :date_created, :cover_url]
  defstruct @enforce_keys
end
