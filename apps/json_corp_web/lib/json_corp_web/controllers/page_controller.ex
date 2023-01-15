defmodule JsonCorpWeb.PageController do
  use JsonCorpWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def consulting(conn, _params) do
    render(conn, :consulting)
  end

  def project(conn, _params) do
    render(conn, :project, projects: projects())
  end

  defp projects() do
    [
      %{
        name: "Test API",
        description: "Simple API that is (maybe) useful for testing",
        url: "https://json.media/test_api"
      }
    ]
  end
end
