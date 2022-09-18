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
      |> assign_page_meta(%{title: "Blog"})

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
  def render(assigns) do
    ~H"""
    <div class="px-8 py-4">
      <div class="flex justify-between items-baseline">
        <h1 class="mb-4 text-2xl font-bold">Posts</h1>
        <%= link "?", to: "#", phx_click: "open_random_post", class: "" %>
      </div>

      <div class="mb-4 flex">
        <%= live_patch "All", to: Routes.blog_post_index_path(@socket, :index), class: "px-4 first:pl-0 border-r-2 last:border-r-0 #{if @category == nil, do: "font-bold"}" %>
        <%= for category <- @categories do %>
          <%= live_patch category, to: Routes.blog_post_index_path(@socket, :index, category: category), class: "px-4 first:pl-0 border-r-2 last:border-r-0 #{if @category == category, do: "font-bold"}" %>
        <% end %>
      </div>

      <div>
      <%= for %Post{} = post <- posts_of_category(@posts, @category) do %>
        <%= live_redirect to: Routes.blog_post_show_path(@socket, :show, post.slug) do %>
          <article class="py-4 border-b-2 cursor-pointer">
            <h2 class="text-xl"><%= post.title %></h2>
            <%= if post.description do %>
              <p class="mt-2"><%= post.description %></p>
            <% end %>
            <div class="mt-6">
              Date created: <time><%= post.date_created %></time>
            </div>
          </article>
        <% end %>
      <% end %>
      </div>
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
