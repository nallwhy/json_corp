defmodule JsonCorp.Blog.Post do
  @enforce_keys [:slug, :title, :body]
  defstruct @enforce_keys
end
