defmodule JsonCorp.StatsTest do
  use JsonCorp.DataCase, async: true
  use JsonCorp.Stats

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

  describe "get_view_count_by_uri/1" do
    setup do
      insert(:view_log, uri: "https://json.media/blog/post0")
      insert(:view_log, uri: "https://json.media/blog/post0?utm_source=twitter")
      insert(:view_log, uri: "https://json.media/blog/post1")

      :ok
    end

    test "with valid uri" do
      assert Stats.get_view_count_by_uri("https://json.media/blog/post0") == 2
    end

    test "with invalid uri" do
      assert Stats.get_view_count_by_uri("https://json.media/blog/post2") == 0
    end
  end
end
