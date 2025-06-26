defmodule JsonCorpWeb.PageHTML do
  use JsonCorpWeb, :html

  embed_templates "page_html/*"

  attr :name, :string, required: true
  attr :description, :string, required: true
  attr :url, :string, required: true
  def project_card(assigns)
end
