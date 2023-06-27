defmodule JsonCorpWeb.Blog.PostLive.Index do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.Post

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:categories, Blog.list_categories())
      |> reset_assigns()
      |> stream_configure(:posts, dom_id: &"post-#{&1.slug}")
      |> assign_posts()
      |> assign_page_meta(%{title: "Blog"})

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"category" => category}, _uri, socket) do
    socket =
      socket
      |> reset_assigns()
      |> assign(:category, category)
      |> assign_posts()

    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"tag" => tag}, _uri, socket) do
    socket =
      socket
      |> reset_assigns()
      |> assign(:tag, tag)
      |> assign_posts()

    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"random" => _}, _uri, socket) do
    post = socket.assigns.posts |> Enum.random()

    socket =
      socket
      |> push_navigate(to: ~p"/blog/#{post}")

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket = socket |> reset_assigns()

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-between items-baseline">
      <.h1>Posts</.h1>
      <.link navigate={~p"/blog?random"}>?</.link>
    </div>

    <div class="mb-4 flex">
      <.link
        patch={~p"/blog"}
        class={"px-4 first:pl-0 border-r-2 last:border-r-0 #{if @category == nil, do: "font-bold"}"}
      >
        All
      </.link>
      <.link
        :for={category <- @categories}
        patch={~p"/blog?category=#{category}"}
        class={"px-4 first:pl-0 border-r-2 last:border-r-0 #{if @category == category, do: "font-bold"}"}
      >
        <%= category %>
      </.link>
    </div>

    <div>
      <div id="posts" phx-update="stream">
        <.link :for={{dom_id, post} <- @streams.posts} id={dom_id} navigate={~p"/blog/#{post}"}>
          <article class="py-4 border-b-2 cursor-pointer">
            <h2 class="text-xl"><%= post.title %></h2>
            <p :if={post.description} class="mt-2"><%= post.description %></p>
            <div class="mt-6">
              Date created: <time><%= post.date_created %></time>
            </div>
            <div :if={post.tags} class="mt-6">
              <.link :for={tag <- post.tags} patch={~p"/blog?tag=#{tag}"}>
                <span class="mr-2 tag">#<%= tag %></span>
              </.link>
            </div>
          </article>
        </.link>
      </div>
    </div>
    """
  end

  defp assign_posts(socket) do
    filtered_posts =
      Blog.list_posts()
      |> filter_posts(socket.assigns |> Map.take([:category, :tag]))

    socket
    |> stream(:posts, filtered_posts, reset: true)
  end

  defp filter_posts(posts, %{category: category}) when not is_nil(category) do
    posts |> Enum.filter(&Post.is_category(&1, category))
  end

  defp filter_posts(posts, %{tag: tag}) when not is_nil(tag) do
    posts |> Enum.filter(&Post.has_tag(&1, tag))
  end

  defp filter_posts(posts, _) do
    posts
  end

  defp reset_assigns(socket) do
    socket
    |> assign(:category, nil)
    |> assign(:tag, nil)
  end
end
