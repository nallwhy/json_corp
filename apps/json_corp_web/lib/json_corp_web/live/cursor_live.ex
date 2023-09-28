defmodule JsonCorpWeb.CursorLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(x: nil, y: nil, base_x: nil, base_y: nil)

    {:ok, socket, layout: false}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="cursor-container" phx-hook="Cursor">
    asf
      <ul :if={@x} class="list-none">
        <li
          style={"color: deeppink; left: #{@x + @base_x}px; top: #{@y + @base_y}px"}
          class="flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden"
        >
          <Icon.cursor />
        </li>
      </ul>
    </div>
    """
  end

  @impl true
  def handle_event("cursor-move", %{"x" => x, "y" => y, "base_x" => base_x, "base_y" => base_y}, socket) do
    socket =
      socket
      |> assign(x: x, y: y, base_x: base_x, base_y: base_y)

    {:noreply, socket}
  end
end
