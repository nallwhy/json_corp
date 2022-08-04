defmodule JsonCorp.Blog.Post do
  @type t :: %__MODULE__{
          title: String.t(),
          slug: String.t(),
          body: String.t()
        }

  @enforce_keys [:slug, :title, :body]
  defstruct @enforce_keys
end
