defmodule JsonCorpWeb.Blog.PostLive.Index do
  use JsonCorpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    Blog List
    """
  end
end
