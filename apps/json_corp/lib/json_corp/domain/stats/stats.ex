defmodule JsonCorp.Stats do
  use Nebulex.Caching
  alias JsonCorp.Stats.ViewLog
  alias JsonCorp.Repo
  alias JsonCorp.Core.Cache

  defmacro __using__([]) do
    quote do
      alias unquote(__MODULE__)
      alias unquote(__MODULE__).ViewLog
    end
  end

  def create_view_log(params) do
    params = params |> Map.put(:created_at, DateTime.utc_now())

    ViewLog.create(params)
    |> Repo.insert()
  end

  @decorate cacheable(
              cache: Cache,
              key: {Stats, :get_view_count_by_uri, [uri]},
              opts: [ttl: :timer.minutes(1)]
            )
  @spec get_view_count_by_uri(uri :: String.t()) :: integer()
  def get_view_count_by_uri(uri) do
    ViewLog.get_count_by_uri(uri)
    |> Repo.one()
  end
end
