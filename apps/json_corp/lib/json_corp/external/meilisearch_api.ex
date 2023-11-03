defmodule JsonCorp.External.MeilisearchAPI do
  use JsonCorp.External
  alias JsonCorp.Core.NDJSON

  def health(%{host: host, api_key: api_key}) do
    request(:get, "/health", base_url: host, auth: api_key)
    |> Ok.map(fn %{body: %{"status" => status}} -> %{status: status} end)
  end

  def create_index(%{index_uid: index_uid} = params, %{host: host, api_key: api_key}) do
    body = %{"uid" => index_uid, "primaryKey" => params[:primary_key]}

    request(:post, "/indexes", json: body, base_url: host, auth: api_key)
    |> Ok.map(fn %{body: body} -> parse_index_task(body) end)
  end

  def delete_index(%{index_uid: index_uid}, %{host: host, api_key: api_key}) do
    request(:delete, "/indexes/#{index_uid}", base_url: host, auth: api_key)
    |> Ok.map(fn %{body: body} -> parse_index_task(body) end)
  end

  def get_task(%{task_uid: task_uid}, %{host: host, api_key: api_key}) do
    request(:get, "/tasks/#{task_uid}", base_url: host, auth: api_key)
    |> Ok.map(fn %{body: body} -> parse_task(body) end)
  end

  def add_or_replace_documents(%{index_uid: index_uid, documents: documents}, %{
        host: host,
        api_key: api_key
      }) do
    request(:post, "/indexes/#{index_uid}/documents",
      headers: [{"Content-type", "application/x-ndjson"}],
      body: documents |> NDJSON.encode(),
      base_url: host,
      auth: api_key
    )
    |> Ok.map(fn %{body: body} -> parse_index_task(body) end)
  end

  def search(%{index_uid: index_uid} = params, pagination, %{host: host, api_key: api_key}) do
    body = %{
      "q" => params[:q],
      "offset" => pagination[:offset],
      "limit" => pagination[:limit]
    }

    request(:post, "/indexes/#{index_uid}/search", json: body, base_url: host, auth: api_key)
    |> Ok.map(fn %{
                   body: %{
                     "hits" => hits,
                     "offset" => offset,
                     "limit" => limit,
                     "estimatedTotalHits" => total
                   }
                 } ->
      pagination =
        case offset + Enum.count(hits) < total do
          true -> %{offset: offset + limit, limit: limit, total: total}
          false -> nil
        end

      %{hits: hits, pagination: pagination}
    end)
  end

  defp parse_index_task(%{"indexUid" => index_uid} = body) do
    %{index_uid: index_uid}
    |> Map.merge(parse_task(body))
  end

  defp parse_task(%{"uid" => task_uid, "type" => type, "status" => status_str}) do
    %{task_uid: task_uid, type: type, status: parse_task_status(status_str)}
  end

  defp parse_task(%{"taskUid" => task_uid, "type" => type, "status" => status_str}) do
    %{task_uid: task_uid, type: type, status: parse_task_status(status_str)}
  end

  defp parse_task_status(status_str) do
    case status_str do
      "enqueued" -> :enqueued
      "processing" -> :processing
      "succeeded" -> :succeeded
      "failed" -> :failed
      "canceled" -> :canceled
    end
  end

  @impl true
  def handle_response({:ok, %{status: status, body: body}}) when status >= 200 and status < 300 do
    {:ok, %{body: body}}
  end

  @impl true
  def handle_response({:error, error}) do
    {:error, error}
  end

  @impl true
  def default_headers() do
    [
      {"Content-type", "application/json"}
    ]
  end

  @impl true
  def auth(token) do
    {:bearer, token}
  end
end
