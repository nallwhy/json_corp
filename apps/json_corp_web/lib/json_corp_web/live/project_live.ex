defmodule JsonCorpWeb.ProjectLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:projects, projects())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Projects</.h1>
    <div class="flex flex-wrap gap-6">
      <.project_card
        :for={project <- @projects}
        name={project.name}
        description={project.description}
        url={project.url}
      />
    </div>
    """
  end

  defp project_card(assigns) do
    ~H"""
    <div class="card w-96 mx-4 bg-base-100 shadow-xl">
      <div class="card-body">
        <h2 class="card-title"><%= @name %></h2>
        <p><%= @description %></p>
        <div class="card-actions justify-end mt-4">
          <.link href={@url} class="btn btn-primary">Go to Project</.link>
        </div>
      </div>
    </div>
    """
  end

  defp projects() do
    [
      %{
        name: "밥면빵",
        description: "Food concierge service",
        url: "https://rinobr.github.io"
      },
      %{
        name: "Test API",
        description: "Simple API that is (maybe) useful for testing",
        url: "https://json.media/test_api"
      }
    ]
  end
end
