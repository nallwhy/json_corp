defmodule JsonCorp.Stats do
  alias JsonCorp.Stats.ViewLog
  alias JsonCorp.Repo

  def create_view_log(params) do
    params = params |> Map.put(:created_at, DateTime.utc_now())

    ViewLog.create(params)
    |> Repo.insert()
  end
end
