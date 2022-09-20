defmodule JsonCorpWeb.SessionPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn |> get_session(:id) do
      nil -> conn |> put_session(:id, UUID.uuid4())
      _id -> conn
    end
  end
end
