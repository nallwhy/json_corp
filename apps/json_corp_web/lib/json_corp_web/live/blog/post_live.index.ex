defmodule JsonCorpWeb.Blog.PostLive.Index do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.Post

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:posts, Blog.list_posts())
      |> assign(:categories, Blog.list_categories())
      |> assign_new(:page_title, fn -> "Blog" end)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    Post List

    <div>
      <%= for category <- @categories do %>
      <%= live_patch category, to: Routes.blog_post_index_path(@socket, :index, category: category) %>
      <% end %>
    </div>

    <div>
    <%= for %Post{title: title, slug: slug} <- @posts do %>
      <div phx-click="move_to_post" phx-value-post_slug={slug}>
        <p>title: <%= title %></p>
      </div>
    <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("move_to_post", %{"post_slug" => slug}, socket) do
    socket =
      socket
      |> push_redirect(to: Routes.blog_post_show_path(socket, :show, slug))

    {:noreply, socket}
  end
end
