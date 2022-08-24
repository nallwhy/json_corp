defmodule JsonCorpWeb.LayoutView do
  use JsonCorpWeb, :view
  alias JsonCorpWeb.Components.Icon

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def meta(assigns, type) when type in [:title, :description] do
    assigns |> get_in([:page_meta, type])
  end
end
