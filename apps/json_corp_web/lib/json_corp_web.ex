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

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def controller do
    quote do
      use Phoenix.Controller, namespace: JsonCorpWeb

      import Plug.Conn
      import JsonCorpWeb.Gettext

      unquote(verified_routes())
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

  def live_view do
    quote do
      use Phoenix.LiveView, layout: {JsonCorpWeb.LayoutView, :live}

      import Phoenix.Component

      alias JsonCorpWeb.Components.Icon

      def assign_page_meta(socket, meta) when is_map(meta) do
        socket = socket |> assign(:page_meta, meta)

        case meta do
          %{title: title} -> socket |> assign(:page_title, title)
          _ -> socket
        end
      end

      def assign_page_meta(socket, fun) when is_function(fun) do
        assign_page_meta(socket, fun.(socket.assigns))
      end

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

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

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: JsonCorpWeb.Endpoint,
        router: JsonCorpWeb.Router,
        statics: JsonCorpWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
