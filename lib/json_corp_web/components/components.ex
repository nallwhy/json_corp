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
    <header class="navbar w-full place-content-between px-8 py-6">
      <div class="hover-scale-110 w-32 flex-none">
        <.link navigate={~p"/"} class="cursor-pointer text-xl">Json Media</.link>
      </div>
      <div class="hidden flex-1 flex-row items-center justify-between pl-12 sm:flex">
        <div>
          <ul class="flex">
            <li
              :for={{menu_name, menu_route} <- list_menus()}
              class="border-y-4 border-transparent px-2 py-1 hover:border-b-accent"
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
            <Icon.bar_3 class="hover:fill-base-content" width="24" height="24" />
          </label>
          <ul
            tabindex="0"
            class="menu menu-compact dropdown-content bg-base-100 rounded-box border-base-content/10 w-52 border p-2 shadow"
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
    <footer class="footer w-full p-8">
      <div>
        <span class="footer-title">{gettext("Social")}</span>
        <div class="grid grid-flow-col gap-2">
          <a href="https://github.com/nallwhy" target="_blank">
            <Icon.github class="fill-secondary hover:fill-accent" width="24" height="24" />
          </a>
          <a href="https://www.linkedin.com/in/jinkyou-son/" target="_blank">
            <Icon.linkedin class="fill-secondary hover:fill-accent" width="26" height="26" />
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

  attr :title, :string, required: true

  slot :inner_block, required: true
  slot :actions

  def card(assigns) do
    ~H"""
    <div class="card border-secondary mx-4 w-96 border shadow">
      <div class="card-body">
        <h2 class="card-title">{@title}</h2>
        {render_slot(@inner_block)}
        <div class="card-actions mt-4 justify-end">
          {render_slot(@actions)}
        </div>
      </div>
    </div>
    """
  end

  attr :color, :string,
    values: ["primary", "secondary", "accent", "neutral", "info", "success", "warning", "error"],
    default: "primary"

  attr :variant, :string, values: ["solid", "soft", "outline", "ghost", "dash"], default: "solid"

  attr :size, :string, values: ["xs", "sm", "md", "lg", "xl"], default: "md"

  attr :rest, :global, include: ~w(disabled)

  slot :inner_block, required: true

  def button(assigns) do
    variant_class =
      case assigns.variant do
        "solid" -> nil
        "soft" -> "btn-soft"
        "outline" -> "btn-outline"
        "ghost" -> "btn-ghost"
        "dash" -> "btn-dash"
      end

    color_class =
      case assigns.color do
        "primary" -> "btn-primary"
        "secondary" -> "btn-secondary"
        "accent" -> "btn-accent"
        "neutral" -> "btn-neutral"
        "info" -> "btn-info"
        "success" -> "btn-success"
        "warning" -> "btn-warning"
        "error" -> "btn-error"
      end

    size_class =
      case assigns.size do
        "xs" -> "btn-xs"
        "sm" -> "btn-sm"
        "md" -> "btn-md"
        "lg" -> "btn-lg"
        "xl" -> "btn-xl"
      end

    assigns =
      assigns
      |> assign(variant_class: variant_class, color_class: color_class, size_class: size_class)

    ~H"""
    <button class={["btn", @variant_class, @color_class, @size_class]}>
      {render_slot(@inner_block)}
    </button>
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
      {gettext("appearances"), ~p"/appearances"},
      {gettext("playgrounds"), ~p"/playgrounds"},
      {gettext("projects"), ~p"/projects"}
    ]
  end

  attr :current_language, :map, required: true

  # hover, highlight 시의 css 가 제대로 먹히지 않음
  defp language_dropdown(assigns) do
    ~H"""
    <.dropdown
      label={language_label(@current_language)}
      placement="bottom-end"
      toggle_class="bg-base-200 border-base-content/10 text-base-content hover:after:bg-base-300"
      class="bg-base-200 border-base-content/10"
    >
      <.link :for={{language, _} <- languages()} href={"?locale=#{language}"}>
        <.dropdown_button class="text-base-content data-highlighted:bg-base-300">
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
