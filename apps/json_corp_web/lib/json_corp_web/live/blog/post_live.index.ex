defmodule JsonCorpWeb.Blog.PostLive.Index do
  use JsonCorpWeb, :live_view
  alias JsonCorp.Blog
  alias JsonCorp.Blog.Post

  @impl true
  def mount(_params, _session, socket) do
    socket = socket |> assign_new(:posts, fn -> Blog.list_posts() end)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    Post List

    <div>
    <%= for %Post{title: title} <- @posts do %>
      <div>
        <p>title: <%= title %></p>
      </div>
    <% end %>
    </div>
    """
  end
end
