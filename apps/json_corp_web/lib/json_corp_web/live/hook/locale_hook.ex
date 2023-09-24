defmodule JsonCorpWeb.LocaleHook do
  import Phoenix.Component, only: [assign: 3]
  alias JsonCorp.Core.Cldr

  def on_mount(:default, _params, %{"cldr_locale" => cldr_locale}, socket) do
    Cldr.put_locale(cldr_locale)

    socket =
      socket
      |> assign(:locale, cldr_locale)
      |> assign(:language, cldr_locale.language)

    {:cont, socket}
  end
end
