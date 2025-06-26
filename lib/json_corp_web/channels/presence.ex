defmodule JsonCorpWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :json_corp,
    pubsub_server: JsonCorp.PubSub

  def sync_presence_diff(presences, %{joins: joins, leaves: leaves}) do
    presences =
      joins
      |> Enum.reduce(presences, fn {key, %{metas: metas}}, presences ->
        metas
        |> Enum.reduce(presences, fn %{phx_ref: phx_ref} = meta, presences ->
          presences
          |> Map.update(key, %{metas: [meta]}, fn %{metas: old_metas} ->
            case Enum.find_index(old_metas, &(&1.phx_ref == phx_ref)) do
              nil -> %{metas: [meta | old_metas]}
              index -> %{metas: old_metas |> List.replace_at(index, meta)}
            end
          end)
        end)
      end)

    _presences =
      leaves
      |> Enum.reduce(presences, fn {key, %{metas: metas}}, presences ->
        metas
        |> Enum.reduce(presences, fn %{phx_ref: phx_ref}, presences ->
          presences
          |> Map.update(key, %{metas: []}, fn %{metas: old_metas} ->
            case Enum.find_index(old_metas, &(&1.phx_ref == phx_ref)) do
              nil -> %{metas: old_metas}
              index -> %{metas: old_metas |> List.delete_at(index)}
            end
          end)
        end)
      end)
      |> Map.reject(fn {_key, %{metas: metas}} -> Enum.empty?(metas) end)
  end
end
