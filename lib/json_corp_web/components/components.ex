defmodule JsonCorpWeb.Components do
  use JsonCorpWeb, :component
  use Gettext, backend: JsonCorpWeb.Gettext
  alias JsonCorpWeb.Components.Icon

  attr :page_meta, :map, required: true
  attr :title_suffix, :string
  attr :default, :map, required: true

  def head_meta_tags(assigns) do
    page_meta =
      [:title, :description, :keyword, :image]
      |> Map.new(fn key ->
        {key, assigns |> get_in([:page_meta, key]) || assigns.default[key]}
      end)

    assigns =
      assigns
      |> assign(:page_meta, page_meta)

    ~H"""
    <.live_title suffix={@title_suffix}>{@page_meta.title}</.live_title>
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

  attr :language, :map, required: true

  def header(assigns) do
    ~H"""
    <header class="navbar mx-auto max-w-6xl place-content-between px-8 py-6">
      <div class="w-32 flex-none">
        <.link navigate={~p"/"} class="cursor-pointer text-xl hover:font-bold">Json Media</.link>
      </div>
      <div class="hidden flex-1 flex-row items-center justify-between pl-12 sm:flex">
        <div>
          <ul class="flex">
            <li
              :for={{menu_name, menu_route} <- list_menus()}
              class="border-y-2 border-transparent px-2 hover:border-b-primary"
            >
              <.link navigate={menu_route}>{menu_name |> String.capitalize()}</.link>
            </li>
          </ul>
        </div>
        <div>
          <.language_dropdown current_language={@language} />
        </div>
      </div>
      <div class="flex flex-none sm:hidden">
        <div>
          <.language_dropdown current_language={@language} />
        </div>
        <div class="dropdown dropdown-end">
          <label tabindex="0" class="btn btn-ghost">
            <Icon.bar_3 class="hover:fill-black" width="24" height="24" />
          </label>
          <ul
            tabindex="0"
            class="menu menu-compact dropdown-content bg-base-100 rounded-box w-52 border-2 p-2 shadow"
          >
            <li :for={{menu_name, menu_route} <- list_menus()}>
              <.link navigate={menu_route}>{menu_name}</.link>
            </li>
          </ul>
        </div>
      </div>
    </header>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer class="footer mx-auto max-w-6xl p-8">
      <div>
        <span class="footer-title">{gettext("Social")}</span>
        <div class="grid grid-flow-col gap-2">
          <a href="https://github.com/nallwhy" target="_blank">
            <Icon.github class="fill-gray-400 hover:fill-black" width="24" height="24" />
          </a>
          <a href="https://www.linkedin.com/in/jinkyou-son/" target="_blank">
            <Icon.linkedin class="fill-gray-400 hover:fill-black" width="26" height="26" />
          </a>
        </div>
      </div>
    </footer>
    """
  end

  slot :inner_block, required: true

  def h1(assigns) do
    ~H"""
    <h1 class="mb-6 text-3xl font-bold">{render_slot(@inner_block)}</h1>
    """
  end

  slot :inner_block, required: true

  def h2(assigns) do
    ~H"""
    <h1 class="mb-6 text-xl font-bold">{render_slot(@inner_block)}</h1>
    """
  end

  def hr(assigns) do
    ~H"""
    <hr class="mx-auto mt-4 h-px max-w-6xl border-0 bg-gray-200 dark:bg-gray-700" />
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
      {gettext("blog"), ~p"/blog"},
      {gettext("consulting"), ~p"/consulting"},
      {gettext("playgrounds"), ~p"/playgrounds"},
      {gettext("projects"), ~p"/projects"}
    ]
  end

  attr :current_language, :map, required: true

  defp language_dropdown(assigns) do
    ~H"""
    <.dropdown label={language_label(@current_language)} placement="bottom-end">
      <.link :for={{language, _} <- languages()} href={"?locale=#{language}"}>
        <.dropdown_button>
          {language_label(language)}
        </.dropdown_button>
      </.link>
    </.dropdown>
    """
  end

  defp language_label(language) do
    flag =
      languages()
      |> Enum.find_value(fn
        {^language, flag} -> flag
        _ -> nil
      end)

    name = language |> Cldr.LocaleDisplay.display_name!()

    "#{flag} #{name}"
  end

  defp languages() do
    [{"ko", "🇰🇷"}, {"en", "🇺🇸"}, {"ja", "🇯🇵"}]
  end

  # Fluxon components

  use Fluxon, avoid_conflicts: true

  defdelegate dropdown(assigns), to: Fluxon.Components.Dropdown
  defdelegate dropdown_button(assigns), to: Fluxon.Components.Dropdown
end
