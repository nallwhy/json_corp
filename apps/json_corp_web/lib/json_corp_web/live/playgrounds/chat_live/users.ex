defmodule JsonCorpWeb.Playgrounds.ChatLive.Users do
  use JsonCorpWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{user: user, presences: presences}, socket) do
    {me, others} =
      presences
      |> Map.new(fn {user_id, presence} -> {user_id, convert_presence_to_user(presence)} end)
      |> Map.pop(user.id)

    socket =
      socket
      |> assign(:me, me)
      |> assign(:others, others)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-4 py-2 rounded-md bg-slate-50">
      Users
      <li :if={@me}>
        <%= @me.name %> <span class="ml-1">(Me)</span>
      </li>
      <li :for={{_other_id, other} <- @others}>
        <%= other.name %>
      </li>
    </div>
    """
  end

  defp convert_presence_to_user(nil) do
    nil
  end

  defp convert_presence_to_user(%{metas: [last_meta | _]}) do
    %{name: last_meta.name}
  end
end
