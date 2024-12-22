defmodule JsonCorpWeb.CursorHook do
  import Phoenix.LiveView, only: [connected?: 1, attach_hook: 4]
  import Phoenix.Component, only: [assign: 2]

  def on_mount(:default, _params, _sessions, socket) do
    socket =
      socket
      |> attach_hook(:cursor_hook, :handle_params, fn _params, uri, socket ->
        if connected?(socket) do
          :ok =
            Registry.dispatch(Registry.WSConnRegistry, socket.assigns.ws_conn_id, fn [{pid, _}] ->
              send(pid, {:uri_changed, uri})
            end)
        end

        socket =
          socket
          |> assign(uri: uri)

        {:cont, socket}
      end)

    {:cont, socket}
  end
end
