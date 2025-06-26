defmodule JsonCorpWeb.ViewLogHook do
  import Phoenix.LiveView
  alias JsonCorp.Stats

  def on_mount(:default, _params, _session, socket) do
    socket =
      socket
      |> attach_hook(:view_log_hook, :handle_params, fn _params, uri, socket ->
        if connected?(socket) do
          Task.start(fn ->
            Stats.create_view_log(%{session_id: socket.assigns.session_id, uri: uri})
          end)
        end

        {:cont, socket}
      end)

    {:cont, socket}
  end
end
