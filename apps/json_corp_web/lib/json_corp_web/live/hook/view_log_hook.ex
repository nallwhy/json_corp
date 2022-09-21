defmodule JsonCorpWeb.ViewLogHook do
  import Phoenix.LiveView
  alias JsonCorp.Stats

  def on_mount(:default, _params, %{"id" => id}, socket) do
    socket =
      socket
      |> attach_hook(:view_log_hook, :handle_params, fn _params, uri, socket ->
        if connected?(socket) do
          Task.start(fn ->
            Stats.create_view_log(%{session_id: id, uri: uri})
          end)
        end

        {:cont, socket}
      end)

    {:cont, socket}
  end
end
