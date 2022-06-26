defmodule JsonCorpWeb.Blog.PostLive.Show do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.Post

  def mount(%{"slug" => slug}, _session, socket) do
    socket = socket |> assign_new(:post, fn -> load_post(slug) end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1><%= @post.title %></h1>
      <p><%= @post.body %></p>
    </div>
    """
  end

  defp load_post(slug) do
    {:ok, %Post{} = post} = Blog.fetch_post(slug)

    post
  end
end
