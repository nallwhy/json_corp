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
    <.h1>{gettext("projects") |> String.capitalize()}</.h1>
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
    <div class="card bg-base-100 mx-4 w-96 shadow-xl">
      <div class="card-body">
        <h2 class="card-title">{@name}</h2>
        <p>{@description}</p>
        <div class="card-actions mt-4 justify-end">
          <.link href={@url} class="btn btn-primary" target="_blank">Go to Project</.link>
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
        name: "reflow",
        description: "Get your Tableau report in Slack",
        url: "https://reflow.work"
      }
    ]
  end
end
