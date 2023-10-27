defmodule JsonCorp.Internal.Meilisearch do
  def host() do
    Application.get_env(:json_corp, :meilisearch)[:host]
  end

  def api_key() do
    Application.get_env(:json_corp, :meilisearch)[:api_key]
  end
end
