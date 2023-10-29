defmodule JsonCorp.Worker.BlogSearchIndexer do
  use Task
  alias JsonCorp.Blog
  alias JsonCorp.Search

  @index_uid "blog_posts"

  def start_link(_) do
    Task.start_link(&run/0)
  end

  def run() do
    posts = Blog.list_posts()

    Search.create_index(@index_uid, :id)
    Search.upsert_documents(@index_uid, posts)
  end
end
