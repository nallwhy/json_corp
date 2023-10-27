defmodule JsonCorp.External.MeilisearchAPI do
  use JsonCorp.External

  def health(%{host: host, api_key: api_key}) do
    request(:get, "/health", base_url: host, auth: api_key)
    |> Ok.map(fn %{body: %{"status" => status}} -> %{status: status} end)
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
