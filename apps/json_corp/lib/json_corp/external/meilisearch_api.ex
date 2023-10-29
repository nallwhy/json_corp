defmodule JsonCorp.External.MeilisearchAPI do
  use JsonCorp.External

  def health(%{host: host, api_key: api_key}) do
    request(:get, "/health", base_url: host, auth: api_key)
    |> Ok.map(fn %{body: %{"status" => status}} -> %{status: status} end)
  end

  def create_index(%{index_uid: index_uid} = params, %{host: host, api_key: api_key}) do
    body = %{"uid" => index_uid, "primaryKey" => params[:primary_key]}

    request(:post, "/indexes", json: body, base_url: host, auth: api_key)
    |> Ok.map(fn %{
                   body: %{
                     "indexUid" => index_uid,
                     "taskUid" => task_uid,
                     "status" => status_str,
                     "type" => type
                   }
                 } ->
      %{
        index_uid: index_uid,
        task_uid: task_uid,
        status: parse_task_status(status_str),
        type: type
      }
    end)
  end

  def get_task(%{task_uid: task_uid}, %{host: host, api_key: api_key}) do
    request(:get, "/tasks/#{task_uid}", base_url: host, auth: api_key)
    |> Ok.map(fn %{body: %{"uid" => task_uid, "type" => type, "status" => status_str}} ->
      %{task_uid: task_uid, type: type, status: parse_task_status(status_str)}
    end)
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
