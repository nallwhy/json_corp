defmodule JsonCorp.Blog.Post do
  @type t :: %__MODULE__{
          title: String.t(),
          category: atom(),
          slug: String.t(),
          body: String.t()
        }

  @enforce_keys [:title, :category, :slug, :body]
  defstruct @enforce_keys
end
