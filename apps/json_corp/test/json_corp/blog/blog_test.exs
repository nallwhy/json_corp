defmodule JsonCorp.BlogTest do
  use ExUnit.Case, async: true
  alias JsonCorp.Blog

  @fixture_path JsonCorp.Fixture.path("./blog")
  test "list_posts/1" do
    assert fetched_posts = Blog.list_posts(@fixture_path)
    assert fetched_posts |> Enum.count() == 2

    [fetched_post | _] = fetched_posts

    assert fetched_post.title == "Test Title 0"
    assert fetched_post.body =~ "# Test Body"
  end
end
