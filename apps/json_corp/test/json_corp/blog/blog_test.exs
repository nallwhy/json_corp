defmodule JsonCorp.BlogTest do
  use ExUnit.Case, async: true
  alias JsonCorp.Blog

  @fixture_path JsonCorp.Fixture.path("./blog")

  test "list_posts/1" do
    assert fetched_posts = Blog.list_posts(@fixture_path)
    assert fetched_posts |> Enum.count() == 2

    [fetched_post | _] = fetched_posts

    assert fetched_post.slug == "post00"
    assert fetched_post.title == "Test Title 0"
    assert fetched_post.body =~ "# Test Body"
  end

  describe "fetch_post/2" do
    test "with valid slug" do
      assert {:ok, fetched_post} = Blog.fetch_post("post0", @fixture_path)

      assert fetched_post.slug == "post0"
      assert fetched_post.title == "Test Title 1"
      assert fetched_post.body =~ "# Test Body"
    end

    test "with invalid slug" do
      assert :error = Blog.fetch_post("post", @fixture_path)
    end
  end
end
