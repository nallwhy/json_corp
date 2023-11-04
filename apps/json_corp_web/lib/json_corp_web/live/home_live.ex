defmodule JsonCorpWeb.HomeLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1><%= gettext("Welcome to %{name}!", name: "Json Media") %></.h1>
    <p>I'm a purely arrogant person.</p>
    <p>I love to observe, interpret, explain, and change the world.</p>
    <br />
    <p>Co-Founder of <.link href="https://reflow.work" target="_blank" class="link">reflow</.link></p>
    <p>
      Co-Organizer of
      <.link href="https://www.facebook.com/groups/elixir.korea" target="_blank" class="link">
        Elixir Korea
      </.link>
      and
      <.link href="https://meetup.com/ko-kr/seoul-elixir-meetup/" target="_blank" class="link">
        Seoul Elixir Meetup
      </.link>
    </p>
    <br />
    <p>
      This site is made with
      <.link href="https://github.com/phoenixframework/phoenix" class="link">Phoenix</.link> &
      <.link href="https://github.com/phoenixframework/phoenix_live_view" class="link">Phoenix LiveView</.link>.
    </p>
    <.link href="https://github.com/nallwhy/json_corp" class="link">GitHub Repository</.link>
    """
  end
end
