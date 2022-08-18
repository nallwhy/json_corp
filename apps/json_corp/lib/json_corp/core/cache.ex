defmodule JsonCorp.Core.Cache do
  use Nebulex.Cache,
    otp_app: :json_corp,
    adapter: Nebulex.Adapters.Local

  def default_matcher({:ok, _}), do: true
  def default_matcher(_), do: false
end
