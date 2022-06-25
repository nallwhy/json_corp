defmodule JsonCorp.Blog do
  alias JsonCorp.Blog.Post

  @spec list_posts :: [%Post{title: String.to(), body: String.t() | nil}]
  def list_posts() do
    [
      %Post{title: "test", body: nil}
    ]
  end
end
