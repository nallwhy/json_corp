defmodule JsonCorpWeb.LocaleHook do
  import Phoenix.Component, only: [assign: 3]
  alias JsonCorp.Core.Cldr

  def on_mount(:default, _params, %{"cldr_locale" => locale_str}, socket) do
    {:ok, locale} = Cldr.put_locale(locale_str)

    socket =
      socket
      |> assign(:locale, locale)

    {:cont, socket}
  end
end
