defmodule JsonCorpWeb.Components do
  use JsonCorpWeb, :component
  alias JsonCorpWeb.Components.Icon

  attr :page_meta, :map, required: true
  attr :title_suffix, :string
  attr :default, :map, required: true

  def head_meta_tags(assigns) do
    page_meta =
      [:title, :description, :keyword, :image]
      |> Map.new(fn key -> {key, assigns |> get_in([:page_meta, key]) || assigns.default[key]} end)

    assigns =
      assigns
      |> assign(:page_meta, page_meta)

    ~H"""
    <.live_title suffix={@title_suffix}><%= @page_meta.title %></.live_title>
    <meta name="title" content={@page_meta.title} />
    <meta property="og:title" content={@page_meta.title} />
    <meta name="description" content={@page_meta.description} />
    <meta property="og:description" content={@page_meta.description} />
    <meta name="keyword" content={@page_meta.keyword |> Enum.join(",")} />
    <meta property="og:image" content={normalize_image(@page_meta.image)} />
    <meta property="og:type" content="website" />
    <meta name="twitter:card" content="summary_large_image" />
    """
  end

  def header(assigns) do
    ~H"""
    <header class="navbar max-w-6xl mx-auto px-8 py-6 place-content-between">
      <div class="flex-none w-32">
        <.link navigate={~p"/"} class="cursor-pointer text-xl hover:font-bold">Json Media</.link>
      </div>
      <div class="hidden sm:block flex-1 pl-12">
        <ul class="flex">
          <li
            :for={{menu_name, menu_route} <- list_menus()}
            class="px-2 border-y-2 border-transparent hover:border-b-primary"
          >
            <.link navigate={menu_route}><%= menu_name %></.link>
          </li>
        </ul>
      </div>
      <div class="sm:hidden flex-none">
        <div class="dropdown dropdown-end">
          <label tabindex="0" class="btn btn-ghost">
            <Icon.bar_3 class="hover:fill-black" width="24" height="24" />
          </label>
          <ul
            tabindex="0"
            class="menu menu-compact dropdown-content p-2 shadow bg-base-100 rounded-box w-52 border-2"
          >
            <li :for={{menu_name, menu_route} <- list_menus()}>
              <.link navigate={menu_route}><%= menu_name %></.link>
            </li>
          </ul>
        </div>
      </div>
    </header>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer class="footer max-w-6xl mx-auto p-8">
      <div>
        <span class="footer-title">Social</span>
        <div class="grid grid-flow-col gap-4">
          <a href="https://github.com/nallwhy" target="_blank">
            <Icon.github class="fill-gray-400 hover:fill-black" width="24" height="24" />
          </a>
          <a href="https://twitter.com/json_do" target="_blank">
            <Icon.twitter class="fill-gray-400 hover:fill-black" width="24" height="24" />
          </a>
        </div>
      </div>
    </footer>
    """
  end

  slot :inner_block, required: true

  def h1(assigns) do
    ~H"""
    <h1 class="text-2xl mb-4 font-bold"><%= render_slot(@inner_block) %></h1>
    """
  end

  slot :inner_block, required: true

  def h2(assigns) do
    ~H"""
    <h1 class="text-xl mb-4 font-bold"><%= render_slot(@inner_block) %></h1>
    """
  end

  def hr(assigns) do
    ~H"""
    <hr class="max-w-6xl mx-auto mt-4 h-px bg-gray-200 border-0 dark:bg-gray-700" />
    """
  end

  defp normalize_image(image) do
    cond do
      image == nil -> nil
      String.starts_with?(image, "http") -> image
      true -> JsonCorpWeb.Endpoint.url() <> image
    end
  end

  defp list_menus() do
    [
      {"Blog", ~p"/blog"},
      {"Consulting", ~p"/consulting"},
      {"Playgrounds", ~p"/playgrounds"},
      {"Projects", ~p"/projects"}
    ]
  end
end
