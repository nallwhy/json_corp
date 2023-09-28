defmodule JsonCorpWeb.CursorLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div></div>
    """
  end
end
