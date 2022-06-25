defmodule JsonCorp.Blog.Post do
  @enforce_keys [:title, :body]
  defstruct @enforce_keys
end
