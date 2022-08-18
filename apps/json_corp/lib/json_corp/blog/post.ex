defmodule JsonCorp.Blog.Post do
  @type t :: %__MODULE__{
          title: String.t(),
          category: atom(),
          slug: String.t(),
          body: String.t(),
          date: Date.t()
        }

  @enforce_keys [:title, :category, :slug, :body, :date]
  defstruct @enforce_keys
end
