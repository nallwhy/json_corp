defmodule JsonCorpWeb.Components do
  use JsonCorpWeb, :component
  alias JsonCorpWeb.Components.Icon

  def meta(assigns) do
    ~H"""
    <meta name="description" content={meta_of(assigns, :description) || "Json's Playground"} />
    <meta
      name="keywords"
      content={
        meta_of(assigns, :keywords) || "Software Development, Software Engineer, Consulting, Elixir"
      }
    />
    <meta property="og:title" content={meta_of(assigns, :title) || "Json Media"} />
    <meta property="og:description" content={meta_of(assigns, :description)} />
    <meta :if={image = meta_of(assigns, :image)} property="og:image" content={image} />
    """
  end

  def header(assigns) do
    ~H"""
    <header class="navbar max-w-6xl mx-auto px-8 py-6 place-content-between">
      <div class="flex-none w-32">
        <.link href={~p"/"} class="cursor-pointer text-xl hover:font-bold">Json Media</.link>
      </div>
      <div class="hidden sm:block flex-1 pl-12">
        <ul class="flex">
          <li
            :for={{menu_name, menu_route} <- list_menus()}
            class="px-2 border-y-2 border-transparent hover:border-b-primary"
          >
            <.link href={menu_route}><%= menu_name %></.link>
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
              <.link href={menu_route}><%= menu_name %></.link>
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

  defp meta_of(assigns, type) when type in [:title, :description, :keywords] do
    assigns |> get_in([:page_meta, type])
  end

  defp meta_of(assigns, :image) do
    image = assigns |> get_in([:page_meta, :image])

    cond do
      image == nil -> nil
      String.starts_with?(image, "https://") -> image
      true -> JsonCorpWeb.Endpoint.url() <> image
    end
  end

  defp list_menus() do
    [
      # TODO: follow user language
      {"Blog", ~p"/blog/ko"},
      {"Consulting", ~p"/consulting"},
      {"Playgrounds", ~p"/playgrounds"},
      {"Projects", ~p"/projects"}
    ]
  end
end
