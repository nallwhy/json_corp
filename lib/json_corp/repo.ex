defmodule JsonCorp.Repo do
  use Ecto.Repo,
    otp_app: :json_corp,
    adapter: Ecto.Adapters.Postgres
end
