defmodule JsonCorp.Blog.Post do
  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          category: atom(),
          slug: String.t(),
          body: String.t(),
          date_created: Date.t()
        }

  @enforce_keys [:title, :description, :category, :slug, :body, :date_created]
  defstruct @enforce_keys
end
