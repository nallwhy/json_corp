defmodule JsonCorpWeb.ProjectController do
  use JsonCorpWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
