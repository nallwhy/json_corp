defmodule JsonCorp.Blog do
  use JsonCorp.Core.Cache
  alias JsonCorp.Blog.{Post, SecretPost, Comment}
  alias JsonCorp.Repo

  defmacro __using__([]) do
    quote do
      alias JsonCorp.Blog
      alias JsonCorp.Blog.{Post, SecretPost, Comment}
    end
  end

  @default_language_order ["en", "ko", "ja"]

  @decorate cacheable(
              cache: Cache.Local,
              key: {Blog, :list_posts_by_language, [language, posts_path]},
              opts: cache_opts()
            )
  @spec list_posts_by_language(language :: String.t()) :: [Post.t()]
  def list_posts_by_language(language, posts_path \\ posts_path()) do
    language_order = [language | @default_language_order]

    list_posts(posts_path)
    |> Enum.group_by(& &1.slug)
    |> Enum.map(fn {_slug, posts} ->
      posts
      |> Enum.sort_by(fn post -> Enum.find_index(language_order, &(&1 == post.language)) end)
      |> List.first()
    end)
    |> Enum.sort_by(fn %Post{date_created: date_created} -> date_created end, {:desc, Date})
  end

  @spec list_posts() :: [Post.t()]
  def list_posts(posts_path \\ posts_path()) do
    list_post_paths(posts_path)
    |> Enum.map(&Post.read/1)
    |> Enum.filter(&(&1.category in list_categories() and &1.status == :published))
    |> Enum.sort_by(fn %Post{date_created: date_created} -> date_created end, {:desc, Date})
  end

  @decorate cacheable(
              cache: Cache.Local,
              key: {Blog, :fetch_post, [language, slug, posts_path]},
              match: &Cache.default_matcher/1,
              opts: cache_opts()
            )
  @spec fetch_post(language :: String.t(), slug :: String.t()) ::
          {:ok, %Post{} | %SecretPost{}, list(%Post{} | %SecretPost{})} | {:error, :not_found}
  def fetch_post(language, slug, posts_path \\ posts_path()) do
    posts =
      list_posts(posts_path)
      |> Enum.filter(fn post -> slug == post.slug or slug in post.aliases end)

    posts
    |> Enum.find_index(&(&1.language == language))
    |> case do
      nil ->
        fetch_secret_post(slug)

      index ->
        {post, candidates} = posts |> List.pop_at(index)

        {:ok, post, candidates}
    end
  end

  def create_comment(params) do
    Comment.Command.create(params)
    |> Repo.insert()
  end

  def list_comments(%{post_slug: post_slug, session_id: session_id}) do
    Comment.Query.list_by_post_slug(post_slug)
    |> Repo.all()
    |> Enum.reject(fn
      %Comment{confirmed_at: nil, session_id: comment_session_id} ->
        comment_session_id != session_id

      _ ->
        false
    end)
    |> then(&{:ok, &1})
  end

  def fetch_comment(comment_id) do
    Comment.Query.get(comment_id)
    |> Repo.one()
    |> case do
      %Comment{} = comment -> {:ok, comment}
      nil -> {:error, :not_found}
    end
  end

  def delete_comment(comment_id, email) do
    with {:ok, comment} <- fetch_comment(comment_id),
         {:deletable, true} <- {:deletable, comment.email == email},
         {:ok, deleted_comment} <- comment |> Comment.Command.delete() |> Repo.update() do
      {:ok, deleted_comment}
    else
      {:deletable, false} -> {:error, :unauthorized}
      error -> error
    end
  end

  defp fetch_secret_post(slug) do
    SecretPost.fetch(slug)
    |> Repo.one()
    |> case do
      %SecretPost{} = secret_post -> {:ok, secret_post, []}
      nil -> {:error, :not_found}
    end
  end

  @spec list_categories() :: [atom()]
  def list_categories() do
    [:dev, :consulting, :essay]
  end

  defp list_post_paths(posts_path) do
    (posts_path <> "/**/*.{md,livemd}")
    |> Path.wildcard()
  end

  defp posts_path() do
    Application.app_dir(:json_corp, "priv/posts")
  end

  case Mix.env() do
    :dev -> defp cache_opts(), do: [ttl: 0]
    _ -> defp cache_opts(), do: [ttl: :infinity]
  end
end
