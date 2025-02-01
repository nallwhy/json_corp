defmodule JsonCorpWeb.HomeLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>{gettext("Welcome to %{name}!", name: "Json Media")}</.h1>
    <p>I'm a purely arrogant person.</p>
    <p>I love to observe, interpret, explain, and change the world.</p>
    <br />
    <p>
      Co-Organizer of
      <.link href="https://discord.gg/dsvYcXzASU" target="_blank" class="link">
        Elixir Korea
      </.link>
    </p>
    <br />
    <p>
      This site is made with <.link
        href="https://github.com/phoenixframework/phoenix_live_view"
        class="link"
      >Phoenix LiveView</.link>.
    </p>
    <.link href="https://github.com/nallwhy/json_corp" class="link">
      GitHub Repository of thie site
    </.link>
    """
  end
end
