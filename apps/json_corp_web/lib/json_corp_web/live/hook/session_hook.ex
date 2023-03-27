defmodule JsonCorpWeb.SessionHook do
  import Phoenix.Component, only: [assign: 3]

  def on_mount(:default, _params, %{"session_id" => session_id}, socket) do
    socket =
      socket
      |> assign(:session_id, session_id)

    {:cont, socket}
  end
end
