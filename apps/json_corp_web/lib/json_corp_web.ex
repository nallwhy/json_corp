defmodule JsonCorpWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use JsonCorpWeb, :controller
      use JsonCorpWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon apple-touch-icon robots.txt sitemap)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import JsonCorpWeb.Gettext
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: JsonCorpWeb,
        formats: [:html, :json],
        layouts: [html: JsonCorpWeb.Layouts]

      import Plug.Conn
      import JsonCorpWeb.Gettext

      unquote(verified_routes())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      import Phoenix.HTML

      alias Phoenix.LiveView.JS

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView, layout: {JsonCorpWeb.Layouts, :app}

      import Phoenix.Component

      alias JsonCorpWeb.Components.Icon

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      import Phoenix.HTML.Form
      import Phoenix.View

      # Core UI components and translation
      import JsonCorpWeb.CoreComponents
      import JsonCorpWeb.Components
      import JsonCorpWeb.Gettext
      import JsonCorpWeb.LiveHelpers

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      alias Doumi.Phoenix.Params

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: JsonCorpWeb.Endpoint,
        router: JsonCorpWeb.Router,
        statics: JsonCorpWeb.static_paths()
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/json_corp_web/templates",
        namespace: JsonCorpWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [view_module: 1, view_template: 1]

      import Phoenix.Component

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.Component

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import JsonCorpWeb.ErrorHelpers
      import JsonCorpWeb.Gettext

      unquote(verified_routes())
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
