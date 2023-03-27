defmodule JsonCorpWeb.SessionPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # for migration
    case {get_session(conn, :session_id), get_session(conn, :id)} do
      {nil, nil} -> conn |> put_session(:session_id, UUID.uuid4())
      {nil, old_session_id} -> conn |> put_session(:session_id, old_session_id)
      {_session_id, _} -> conn
    end
  end
end
