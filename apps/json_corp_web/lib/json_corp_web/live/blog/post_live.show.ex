defmodule JsonCorpWeb.Blog.PostLive.Show do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.Post
  alias JsonCorp.Blog.MarkdownRenderer
  alias JsonCorp.Stats

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:post, load_post(slug))
      |> assign(:view_count, nil)
      |> assign_page_meta(fn %{
                               post: %{
                                 title: title,
                                 description: description,
                                 cover_url: cover_url
                               }
                             } ->
        %{title: title, description: description, cover_url: cover_url}
      end)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    normalized_uri =
      uri |> URI.parse() |> Map.merge(%{fragment: nil, query: nil}) |> URI.to_string()

    socket =
      socket
      |> assign(:view_count, load_view_count(normalized_uri))

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-8 py-4">
      <div class="pb-4">
        <.link navigate={Routes.blog_post_index_path(@socket, :index)} class="block mb-6">
          <Icon.arrow_left class="icon mr-1"/><span class="text-gray-500">Back to posts</span>
        </.link>
        <div class="prose">
          <h1><%= @post.title %></h1>
          <p><%= @post.description %></p>
          <div><time>Date created: <%= @post.date_created %></time></div>
          <div>View count: <%= @view_count %></div>
        </div>
      </div>
      <hr class="prose">
      <div class="prose pt-4">
        <%= if @post.cover_url do %>
          <img src={@post.cover_url} alt={@post.title} class="w-full">
        <% end %>
        <%= @post.body |> MarkdownRenderer.html() |> raw() %>
      </div>
    </div>
    """
  end

  defp load_post(slug) do
    {:ok, %Post{} = post} = Blog.fetch_post(slug)

    post
  end

  def load_view_count(uri) do
    Stats.get_view_count_by_uri(uri)
  end
end
