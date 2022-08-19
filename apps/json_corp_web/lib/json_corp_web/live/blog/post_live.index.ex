defmodule JsonCorpWeb.Blog.PostLive.Index do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.Post
  alias JsonCorp.Core.Nillable

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
  def handle_params(params, _uri, socket) do
    category = params |> Map.get("category") |> Nillable.map(&String.to_existing_atom(&1))

    socket = socket |> assign(:category, category)

    {:noreply, socket}
  end

  @impl true
  def handle_event("open_random_post", _, socket) do
    %{slug: post_slug} = socket.assigns.posts |> Enum.random()

    socket =
      socket
      |> push_redirect(to: Routes.blog_post_show_path(socket, :show, post_slug))

    {:noreply, socket}
  end

  @impl true
  def handle_event("open_post", %{"post_slug" => slug}, socket) do
    socket =
      socket
      |> push_redirect(to: Routes.blog_post_show_path(socket, :show, slug))

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    Post List

    <div>
      <%= link "Random", to: "#", phx_click: "open_random_post" %>
      <%= live_patch "All", to: Routes.blog_post_index_path(@socket, :index) %>
      <%= for category <- @categories do %>
      <%= live_patch category, to: Routes.blog_post_index_path(@socket, :index, category: category) %>
      <% end %>
    </div>

    <div>
    <%= for %Post{title: title, slug: slug} <- posts_of_category(@posts, @category) do %>
      <div phx-click="open_post" phx-value-post_slug={slug}>
        <p>title: <%= title %></p>
      </div>
    <% end %>
    </div>
    """
  end

  defp posts_of_category(posts, nil) do
    posts
  end

  defp posts_of_category(posts, category) do
    posts |> Enum.filter(fn %Post{category: post_category} -> post_category == category end)
  end
end