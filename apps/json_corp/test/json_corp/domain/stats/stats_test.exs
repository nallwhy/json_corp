defmodule JsonCorp.StatsTest do
  use JsonCorp.DataCase, async: true
  alias JsonCorp.Stats
  alias JsonCorp.Stats.ViewLog

  describe "create_view_log/1" do
    @params %{
      session_id: Ecto.UUID.generate(),
      uri: "https://example.com"
    }

    test "returns view_log with valid params" do
      assert {:ok, %ViewLog{} = view_log} = Stats.create_view_log(@params)
      assert view_log.session_id == @params.session_id
      assert view_log.uri == @params.uri
      assert view_log.created_at != nil
    end
  end
end
