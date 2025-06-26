defmodule JsonCorpWeb.SearchLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div phx-window-keydown="open_search"></div>
    """
  end

  @impl true
  def handle_event("open_search", params, socket) do
    params |> IO.inspect()

    {:noreply, socket}
  end
end
