defmodule JsonCorpWeb.Playgrounds.ChatLive.Users do
  use JsonCorpWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  # init
  @impl true
  def update(%{id: _} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-4 py-2 rounded-md bg-slate-50">
      Users
      <li :for={{user_id, %{metas: [%{name: name} | _]}} <- @presences}>
        <%= name %><span :if={user_id == @user.id} class="ml-1">(Me)</span>
      </li>
    </div>
    """
  end
end
