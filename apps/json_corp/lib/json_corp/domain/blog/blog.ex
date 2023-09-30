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
    |> Enum.map(&read_post/1)
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

  defp read_post(post_path) do
    post_meta = extract_post_meta(post_path)

    post_path
    |> File.read!()
    |> parse_post(post_meta)
  end

  defp parse_post(raw_post, %{
         language: language,
         slug_with_underscore: slug_with_underscore,
         date_created: date_created
       }) do
    [meta_str, body] =
      raw_post
      |> String.split("---", parts: 2, trim: true)

    {meta_map, _binding} = meta_str |> Code.eval_string()

    title = meta_map |> Map.fetch!(:title)
    category = meta_map |> Map.fetch!(:category)

    default_slug = slug_with_underscore |> String.replace("_", "-")

    %Post{
      title: title,
      description: meta_map[:description],
      language: language,
      category: category,
      slug: meta_map[:slug] || default_slug,
      body: body,
      date_created: date_created,
      cover_url: meta_map[:cover_url],
      tags: meta_map[:tags],
      aliases: [slug_with_underscore | meta_map[:aliases] || []] |> Enum.uniq()
    }
  end

  defp extract_post_meta(post_path) do
    %{"language" => language, "date_created" => date_created_str, "slug" => slug_with_underscore} =
      Regex.named_captures(
        ~r/\/(?<language>[^\/]+)\/[^\/]+\/(?<date_created>\d{8})_(?<slug>.+)\.(md|livemd)$/,
        post_path
      )

    date_created = date_created_str |> Timex.parse!("{YYYY}{0M}{0D}") |> NaiveDateTime.to_date()

    %{language: language, slug_with_underscore: slug_with_underscore, date_created: date_created}
  end

  defp posts_path() do
    Application.app_dir(:json_corp, "priv/posts")
  end

  case Mix.env() do
    :dev -> defp cache_opts(), do: [ttl: 0]
    _ -> defp cache_opts(), do: [ttl: :infinity]
  end
end
