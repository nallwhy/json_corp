defmodule JsonCorpWeb.Blog.PostLive.Show do
  use JsonCorpWeb, :live_view

  def mount(%{"slug" => _slug}, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    Post Show
    """
  end
end
