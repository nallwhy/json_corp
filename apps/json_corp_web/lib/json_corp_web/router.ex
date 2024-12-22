defmodule JsonCorpWeb.Router do
  use JsonCorpWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session

    plug Cldr.Plug.PutLocale,
      apps: [:cldr],
      from: [:query, :session, :accept_language],
      cldr: JsonCorp.Core.Cldr

    plug Cldr.Plug.PutSession, as: :string

    plug :fetch_live_flash
    plug :put_root_layout, {JsonCorpWeb.Layouts, :root}
    plug :protect_from_forgery
    # plug :put_secure_browser_headers, %{"content-security-policy" => "default-src 'self' data:"}
    plug JsonCorpWeb.SessionPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :admin_basic_auth
  end

  # pipeline :test_api do
  #   plug :change_endpoint, TestApiWeb.Endpoint
  # end

  scope "/", JsonCorpWeb do
    pipe_through :browser

    live_session :live,
      on_mount: [
        JsonCorpWeb.SessionHook,
        JsonCorpWeb.ViewLogHook,
        JsonCorpWeb.LocaleHook,
        JsonCorpWeb.CursorHook
      ] do
      live "/", HomeLive
      live "/consulting", ConsultingLive
      live "/projects", ProjectLive

      scope "/blog", Blog do
        live "/", PostLive.Index
        live "/:language", PostLive.Index
        live "/:language/:slug", PostLive.Show
      end

      scope "/playgrounds", Playgrounds do
        live "/", PlaygroundLive
        live "/form", FormLive
        live "/chat", ChatLive
      end
    end

    if Mix.env() == :dev do
      live "/test", TestLive
    end
  end

  # scope "/test_api" do
  #   pipe_through [:test_api]

  #   forward "/", TestApiWeb.Router
  # end

  # Other scopes may use custom stacks.
  # scope "/api", JsonCorpWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admin]

    live_dashboard "/dashboard",
      metrics: JsonCorpWeb.Telemetry,
      ecto_psql_extras_options: [long_running_queries: [threshold: "200 milliseconds"]]
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp admin_basic_auth(conn, _opts) do
    username = System.fetch_env!("AUTH_USERNAME")
    password = System.fetch_env!("AUTH_PASSWORD")

    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end

  # defp change_endpoint(conn, endpoint) do
  #   conn |> put_private(:phoenix_endpoint, endpoint)
  # end
end
