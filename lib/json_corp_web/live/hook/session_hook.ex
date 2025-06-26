defmodule JsonCorpWeb.SessionHook do
  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [connected?: 1, get_connect_params: 1]

  def on_mount(:default, _params, %{"session_id" => session_id}, socket) do
    ws_conn_id =
      case connected?(socket) do
        true -> get_connect_params(socket)["ws_conn_id"]
        false -> nil
      end

    socket =
      socket
      |> assign(:session_id, session_id)
      |> assign(:ws_conn_id, ws_conn_id)

    {:cont, socket}
  end
end
