defmodule JsonCorp.BlogTest do
  use ExUnit.Case, async: true
  alias JsonCorp.Blog

  @fixture_path JsonCorp.Fixture.path("./blog")

  test "list_posts/1" do
    assert fetched_posts = Blog.list_posts(@fixture_path)
    assert fetched_posts |> Enum.count() == 2

    [fetched_post | _] = fetched_posts

    assert fetched_post.title == "Test Title 1"
    assert fetched_post.description == "description 1"
    assert fetched_post.category == "talk"
    assert fetched_post.slug == "post0"
    assert fetched_post.body =~ "# Test Body"
    assert fetched_post.date_created == ~D[2022-07-24]
    assert fetched_post.cover_url == nil
  end

  describe "fetch_post/2" do
    test "with valid slug" do
      assert {:ok, fetched_post} = Blog.fetch_post("post00", @fixture_path)

      assert fetched_post.title == "Test Title 0"
      assert fetched_post.description == "description 0"
      assert fetched_post.category == "dev"
      assert fetched_post.slug == "post00"
      assert fetched_post.body =~ "# Test Body"
      assert fetched_post.date_created == ~D[2022-06-26]
      assert fetched_post.cover_url == "https://json.corp/images/blog/example.jpg"
    end

    test "with invalid slug" do
      assert :error = Blog.fetch_post("post", @fixture_path)
    end
  end
end
