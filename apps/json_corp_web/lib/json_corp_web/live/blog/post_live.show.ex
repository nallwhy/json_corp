defmodule JsonCorpWeb.Blog.PostLive.Show do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.Post
  alias JsonCorp.Blog.MarkdownRenderer

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:post, load_post(slug))
      |> assign_new(:page_title, fn %{post: %{title: title}} -> title end)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <%= link "<- 전체 글 보기", to: Routes.blog_post_index_path(@socket, :index) %>
      </div>
      <div class="prose">
        <h1><%= @post.title %></h1>
        <div>
          <%= @post.body |> MarkdownRenderer.html() |> raw() %>
        </div>
      </div>
    </div>
    """
  end

  defp load_post(slug) do
    {:ok, %Post{} = post} = Blog.fetch_post(slug)

    post
  end
end