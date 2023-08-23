defmodule JsonCorpWeb.Blog.PostLive.Show do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.{Post, SecretPost}
  alias JsonCorp.Blog.MarkdownRenderer
  alias JsonCorp.Stats

  @impl true
  def mount(%{"language" => language, "slug" => slug}, _session, socket) do
    socket =
      socket
      |> assign(:view_count, nil)
      |> load_post(language, slug)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    if connected?(socket) do
      pid = self()

      Task.start(fn ->
        normalized_uri =
          uri |> URI.parse() |> Map.merge(%{fragment: nil, query: nil}) |> URI.to_string()

        view_count = load_view_count(normalized_uri)

        send(pid, {:view_count, view_count})
      end)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("unlock_post", %{"door" => %{"password" => password}}, socket) do
    socket =
      case socket.assigns.post.password do
        ^password ->
          socket
          |> assign(:locked, false)

        _ ->
          socket
          |> put_flash(:error, "Denied")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:view_count, view_count}, socket) do
    socket =
      socket
      |> assign(:view_count, view_count)

    {:noreply, socket}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(%{locked: true} = assigns) do
    ~H"""
    <.form :let={f} for={:door} phx-submit="unlock_post">
      <%= password_input(f, :password, class: "input input-bordered", placeholder: "password") %>

      <button class="btn">Open</button>
    </.form>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="pb-4">
      <.link navigate={~p"/blog/#{@post.language}"} class="block mb-6">
        <Icon.arrow_left class="icon mr-1" /><span class="text-gray-400">Back to posts</span>
      </.link>
      <div class="prose">
        <h1><%= @post.title %></h1>
        <p><%= @post.description %></p>
        <div><time>Date created: <%= @post.date_created %></time></div>
        <div>View count: <%= @view_count || "-" %></div>
      </div>
      <div :if={@post.tags} class="mt-2">
        <.link :for={tag <- @post.tags} navigate={~p"/blog/#{@post.language}?tag=#{tag}"}>
          <span class="mr-2 tag">#<%= tag %></span>
        </.link>
      </div>
    </div>
    <hr class="prose" />
    <div class="prose pt-4">
      <img :if={@post.cover_url} src={@post.cover_url} alt={@post.title} class="w-full" />
      <%= @post.body |> MarkdownRenderer.html() |> raw() %>
    </div>
    """
  end

  defp load_post(socket, language, slug) do
    case Blog.fetch_post(language, slug) do
      {:ok, post} ->
        socket
        |> assign(:post, post)
        |> assign_new(:locked, fn
          %{post: %SecretPost{}} -> true
          %{post: %Post{}} -> false
        end)
        |> assign_page_meta(fn %{
                                 post: %{
                                   title: title,
                                   description: description,
                                   cover_url: cover_url,
                                   tags: tags
                                 }
                               } ->
          %{
            title: title,
            description: description,
            image: cover_url,
            keywords: tags |> Enum.join(", ")
          }
        end)

      {:redirect, post} ->
        socket
        |> push_navigate(to: ~p"/blog/#{post}")

      _ ->
        # TODO: follow user language
        socket
        |> push_navigate(to: ~p"/blog/ko")
    end
  end

  def load_view_count(uri) do
    Stats.get_view_count_by_uri(uri)
  end
end
