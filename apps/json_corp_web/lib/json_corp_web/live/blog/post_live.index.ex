defmodule JsonCorpWeb.Blog.PostLive.Index do
  use JsonCorpWeb, :live_view
  use JsonCorp.Blog
  alias JsonCorp.Core.Cldr

  @impl true
  def mount(%{"language" => language}, _session, socket) do
    socket =
      case language in Cldr.known_languages() do
        true ->
          case socket.assigns.language do
            ^language ->
              socket
              |> assign(:blog_language, language)
              |> assign(:categories, Blog.list_categories())
              |> stream_configure(:posts, dom_id: &"post-#{&1.slug}")
              |> assign(:page_meta, %{title: "Blog", description: "Json's talks"})

            _ ->
              # TODO: go back not working(needs previous language)
              socket
              |> push_navigate(to: ~p"/blog/#{socket.assigns.language}", replace: true)
          end

        false ->
          # redirect to PostLive.Show
          slug = language

          socket
          |> push_navigate(to: ~p"/blog/ko/#{slug}", replace: true)
      end

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    language = socket.assigns.language

    socket =
      socket
      |> push_navigate(to: ~p"/blog/#{language}", replace: true)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"category" => category_str}, _uri, socket) do
    category = category_str |> String.to_existing_atom()

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
    post = Blog.list_posts_by_language(socket.assigns.language) |> Enum.random()

    socket =
      socket
      |> push_navigate(to: ~p"/blog/#{post.language}/#{post.slug}")

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |> reset_assigns()
      |> assign_posts()

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-start justify-between">
      <div class="flex items-center gap-x-4">
        <.h1>{gettext("blog") |> String.capitalize()}</.h1>
      </div>
      <div>
        <.link navigate={~p"/blog/#{@language}?random"}>
          <.icon name="hero-sparkles" class="w-6 h-6" />
        </.link>
      </div>
    </div>

    <div class="mb-4 flex">
      <.link
        patch={~p"/blog/#{@language}"}
        class={"px-4 first:pl-0 border-r-2 last:border-r-0 #{if @category == nil, do: "font-bold"}"}
      >
        All
      </.link>
      <.link
        :for={category <- @categories}
        patch={~p"/blog/#{@language}?category=#{category}"}
        class={"px-4 first:pl-0 border-r-2 last:border-r-0 #{if @category == category, do: "font-bold"}"}
      >
        {category}
      </.link>
    </div>

    <div>
      <div id="posts" class="divide-y" phx-update="stream">
        <div :for={{dom_id, post} <- @streams.posts} id={dom_id}>
          <.link navigate={~p"/blog/#{post.language}/#{post.slug}"}>
            <article class="py-4 cursor-pointer">
              <h2 class="text-xl">{post.title}</h2>
              <p :if={post.description} class="mt-2">{post.description}</p>
              <div class="mt-6">
                Date created: <time>{post.date_created}</time>
              </div>
              <div :if={post.tags} class="mt-6">
                <.link :for={tag <- post.tags} patch={~p"/blog/#{@language}?tag=#{tag}"}>
                  <span class="mr-2 tag">#{tag}</span>
                </.link>
              </div>
            </article>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  defp assign_posts(socket) do
    filtered_posts =
      Blog.list_posts_by_language(socket.assigns.blog_language)
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
