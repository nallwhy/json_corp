defmodule JsonCorpWeb.Components do
  use JsonCorpWeb, :component
  alias JsonCorpWeb.Components.Icon

  def meta(assigns) do
    ~H"""
    <meta name="description" content={meta_of(assigns, :description) || "Json's Playground"} />
    <meta name="keywords" content="software development, software engineer, consulting, elixir" />
    <meta property="og:title" content={meta_of(assigns, :title) || "Json Media"} />
    <meta property="og:description" content={meta_of(assigns, :description)} />
    <%= if cover_url = meta_of(assigns, :cover_url) do %>
      <meta property="og:image" content={cover_url} />
    <% end %>
    """
  end

  def header(assigns) do
    ~H"""
    <header class="px-8 py-6 flex items-center">
      <div class="flex-none w-32">
        <.link href={~p"/"} class="cursor-pointer text-xl hover:font-bold">Json Media</.link>
      </div>
      <div class="flex-1 ml-4">
        <ul class="flex">
          <li class="px-2 border-y-2 border-transparent hover:border-b-primary">
            <.link navigate={~p"/blog"}>Blog</.link>
          </li>
          <li class="px-2 border-y-2 border-transparent hover:border-b-primary">
            <.link href={~p"/consulting"}>Consulting</.link>
          </li>
          <li class="px-2 border-y-2 border-transparent hover:border-b-primary">
            <.link href={~p"/projects"}>Projects</.link>
          </li>
        </ul>
      </div>
    </header>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer class="footer p-8">
      <div>
        <span class="footer-title">Social</span>
        <div class="grid grid-flow-col gap-4">
          <a href="https://github.com/nallwhy" target="_blank">
            <Icon.github class="fill-gray-500 hover:fill-black" width="24" height="24" />
          </a>
        </div>
      </div>
    </footer>
    """
  end

  defp meta_of(assigns, type) when type in [:title, :description] do
    assigns |> get_in([:page_meta, type])
  end

  defp meta_of(assigns, :cover_url) do
    cover_url = assigns |> get_in([:page_meta, :cover_url])

    cond do
      cover_url == nil -> nil
      String.starts_with?(cover_url, "https://") -> cover_url
      true -> JsonCorpWeb.Endpoint.url() <> cover_url
    end
  end
end
