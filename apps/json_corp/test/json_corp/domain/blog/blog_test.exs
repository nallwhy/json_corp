defmodule JsonCorp.BlogTest do
  use JsonCorp.DataCase, async: true
  alias JsonCorp.Blog

  @fixture_path JsonCorp.Fixture.path("./blog")

  test "list_posts_by_language/2" do
    assert fetched_posts = Blog.list_posts_by_language("ko", @fixture_path)
    assert fetched_posts |> Enum.count() == 2

    [fetched_post | _] = fetched_posts

    assert fetched_post.title == "Test Title 1"
    assert fetched_post.description == "description 1"
    assert fetched_post.category == "talk"
    assert fetched_post.slug == "post-0"
    assert fetched_post.body =~ "# Test Body"
    assert fetched_post.date_created == ~D[2022-07-24]
    assert fetched_post.cover_url == nil
    assert fetched_post.tags == nil
    assert fetched_post.aliases == ["post_0"]

    assert fetched_posts = Blog.list_posts_by_language("en", @fixture_path)
    assert fetched_posts |> Enum.count() == 1
  end

  describe "fetch_post/2" do
    test "with valid slug" do
      assert {:ok, fetched_post} = Blog.fetch_post("ko", "post-00", @fixture_path)

      assert fetched_post.title == "Test Title 0"
      assert fetched_post.description == "description 0"
      assert fetched_post.category == "dev"
      assert fetched_post.slug == "post-00"
      assert fetched_post.body =~ "# Test Body"
      assert fetched_post.date_created == ~D[2022-06-26]
      assert fetched_post.cover_url == "/images/blog/example.jpg"
      assert fetched_post.tags == ["tag0", "tag1"]
      assert fetched_post.aliases == ["post_00", "post-000"]
    end

    test "with valid alias" do
      assert {:redirect, fetched_post} = Blog.fetch_post("ko", "post-000", @fixture_path)

      assert fetched_post.title == "Test Title 0"
    end

    test "with valid secret slug" do
      secret_post = insert(:secret_post)

      assert {:ok, fetched_secret_post} = Blog.fetch_post("any", secret_post.slug, @fixture_path)

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
      assert :error = Blog.fetch_post("ko", "post", @fixture_path)
    end
  end

  describe "create_comment/1" do
    test "with valid params" do
      params = %{
        post_slug: "slug",
        session_id: build(:uuid),
        name: "name",
        email: "example@email.com",
        body: "body"
      }

      assert {:ok, comment} = Blog.create_comment(params)

      assert same_fields?(params, comment, [:post_slug, :session_id, :name, :email, :body])
      assert comment.confirmed_at == nil
    end
  end

  describe "list_comments/1" do
    setup do
      session_id = build(:uuid)
      post_slug = "slug"
      now = DateTime.utc_now()

      pending_comment =
        insert(:comment,
          post_slug: post_slug,
          session_id: session_id,
          status: :pending,
          inserted_at: now |> Timex.shift(days: -4)
        )

      confirmed_comment =
        insert(:comment,
          post_slug: post_slug,
          session_id: session_id,
          status: :confirmed,
          inserted_at: now |> Timex.shift(days: -3)
        )

      other_sessions_pending_comment =
        insert(:comment,
          post_slug: post_slug,
          status: :pending,
          inserted_at: now |> Timex.shift(days: -2)
        )

      other_sessions_confirmed_comment =
        insert(:comment,
          post_slug: post_slug,
          status: :confirmed,
          inserted_at: now |> Timex.shift(days: -1)
        )

      other_posts_comment = insert(:comment, inserted_at: now |> Timex.shift(days: -0))

      %{
        post_slug: post_slug,
        session_id: session_id,
        comments: [
          pending_comment,
          confirmed_comment,
          other_sessions_pending_comment,
          other_sessions_confirmed_comment,
          other_posts_comment
        ]
      }
    end

    test "with valid params", %{
      post_slug: post_slug,
      session_id: session_id,
      comments: [
        pending_comment,
        confirmed_comment,
        _other_sessions_pending_comment,
        other_sessions_confirmed_comment,
        _other_posts_comment
      ]
    } do
      assert {:ok, [fetched_comment0, fetched_comment1, fetched_comment2]} =
               Blog.list_comments(%{post_slug: post_slug, session_id: session_id})

      assert same_records?(fetched_comment0, pending_comment)
      assert same_records?(fetched_comment1, confirmed_comment)
      assert same_records?(fetched_comment2, other_sessions_confirmed_comment)
    end
  end
end
