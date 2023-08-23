defmodule JsonCorp.BlogTest do
  use JsonCorp.DataCase, async: true
  alias JsonCorp.Blog

  @fixture_path JsonCorp.Fixture.path("./blog")

  test "list_posts/2" do
    assert fetched_posts = Blog.list_posts("ko", @fixture_path)
    assert fetched_posts |> Enum.count() == 2

    [fetched_post | _] = fetched_posts

    assert fetched_post.title == "Test Title 1"
    assert fetched_post.description == "description 1"
    assert fetched_post.category == "talk"
    assert fetched_post.slug == "post0"
    assert fetched_post.body =~ "# Test Body"
    assert fetched_post.date_created == ~D[2022-07-24]
    assert fetched_post.cover_url == nil
    assert fetched_post.tags == nil

    assert fetched_posts = Blog.list_posts("en", @fixture_path)
    assert fetched_posts |> Enum.count() == 1
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
      assert fetched_post.tags == ["tag0", "tag1"]
      assert fetched_post.aliases == ["post000"]
    end

    test "with valid alias" do
      assert {:redirect, fetched_post} = Blog.fetch_post("post000", @fixture_path)

      assert fetched_post.title == "Test Title 0"
    end

    test "with valid secret slug" do
      secret_post = insert(:secret_post)

      assert {:ok, fetched_secret_post} = Blog.fetch_post(secret_post.slug, @fixture_path)

      assert same_fields?(fetched_secret_post, secret_post, [
               :title,
               :description,
               :category,
               :slug,
               :body,
               :date_created,
               :cover_url,
               :password
             ])
    end

    test "with invalid slug" do
      assert :error = Blog.fetch_post("post", @fixture_path)
    end
  end
end
