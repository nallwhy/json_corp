defmodule JsonCorpWeb.PageController do
  use JsonCorpWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def project(conn, _params) do
    render(conn, :project)
  end
end
