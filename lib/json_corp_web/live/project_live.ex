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
      <.card :for={project <- @projects} title={project.name}>
        <p>{project.description}</p>
        <:actions>
          <.link href={project.url} class="btn btn-primary" target="_blank">Go to Project</.link>
        </:actions>
      </.card>
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
