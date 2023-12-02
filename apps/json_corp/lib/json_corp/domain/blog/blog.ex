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

  @decorate cacheable(
              cache: Cache.Local,
              key: {Blog, :list_posts_by_language, [language, posts_path]},
              opts: cache_opts()
            )
  @spec list_posts_by_language(language :: String.t()) :: [Post.t()]
  def list_posts_by_language(language, posts_path \\ posts_path()) do
    list_posts(posts_path)
    |> Enum.group_by(& &1.language)
    |> Map.get(language, [])
  end

  @spec list_posts() :: [Post.t()]
  def list_posts(posts_path \\ posts_path()) do
    list_post_paths(posts_path)
    |> Enum.map(&Post.read/1)
    |> Enum.sort_by(fn %Post{date_created: date_created} -> date_created end, {:desc, Date})
  end

  @decorate cacheable(
              cache: Cache.Local,
              key: {Blog, :fetch_post, [language, slug, posts_path]},
              match: &Cache.default_matcher/1,
              opts: cache_opts()
            )
  @spec fetch_post(language :: String.t(), slug :: String.t()) ::
          {:ok, %Post{} | %SecretPost{}} | {:redirect, %Post{}} | :error
  def fetch_post(language, slug, posts_path \\ posts_path()) do
    list_posts_by_language(language, posts_path)
    |> Enum.find_value(fn
      %Post{slug: ^slug} = post ->
        {:ok, post}

      %Post{aliases: aliases} = post ->
        case slug in aliases do
          true -> {:redirect, post}
          false -> nil
        end

      _ ->
        nil
    end)
    |> case do
      nil -> fetch_secret_post(slug)
      result -> result
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
      %Comment{session_id: "c5702334-2df5-43a7-b632-1a0ae42d4980"} ->
        false

      %Comment{session_id: "646fc439-c937-4f0c-a948-1d484a259c6e"} ->
        false

      %Comment{confirmed_at: nil, session_id: comment_session_id} ->
        comment_session_id != session_id

      _ ->
        false
    end)
    |> then(&{:ok, &1})
  end

  defp fetch_secret_post(slug) do
    SecretPost.fetch(slug)
    |> Repo.one()
    |> case do
      %SecretPost{} = secret_post -> {:ok, secret_post}
      nil -> :error
    end
  end

  @spec list_categories() :: [atom()]
  def list_categories() do
    [:talk, :business, :dev, :consulting]
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
