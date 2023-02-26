defmodule JsonCorp.Blog do
  use JsonCorp.Core.Cache
  alias JsonCorp.Blog.{Post, SecretPost}
  alias JsonCorp.Repo

  @posts_path Application.app_dir(:json_corp, "priv/posts")

  @decorate cacheable(
              cache: Cache.Local,
              key: {Blog, :list_posts, [posts_path]},
              opts: cache_opts()
            )
  @spec list_posts() :: [Post.t()]
  def list_posts(posts_path \\ @posts_path) do
    list_post_paths(posts_path)
    |> Enum.map(&read_post/1)
    |> Enum.sort_by(fn %Post{date_created: date_created} -> date_created end, {:desc, Date})
  end

  @decorate cacheable(
              cache: Cache.Local,
              key: {Blog, :fetch_post, [slug, posts_path]},
              match: &Cache.default_matcher/1,
              opts: cache_opts()
            )
  @spec fetch_post(slug :: String.t()) :: {:ok, %Post{} | %SecretPost{}} | :error
  def fetch_post(slug, posts_path \\ @posts_path) do
    list_posts(posts_path)
    |> Enum.find(fn %Post{slug: post_slug} -> post_slug == slug end)
    |> case do
      %Post{} = post -> {:ok, post}
      nil -> fetch_secret_post(slug)
    end
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

  defp parse_post(raw_post, %{slug: slug, date_created: date_created}) do
    [meta_str, body] =
      raw_post
      |> String.split("---", parts: 2, trim: true)

    {meta_map, _binding} = meta_str |> Code.eval_string()

    title = meta_map |> Map.fetch!(:title)
    category = meta_map |> Map.fetch!(:category)

    %Post{
      title: title,
      description: meta_map[:description],
      category: category,
      slug: slug,
      body: body,
      date_created: date_created,
      cover_url: meta_map[:cover_url],
      tags: meta_map[:tags]
    }
  end

  defp extract_post_meta(post_path) do
    %{"date_created" => date_created_str, "slug" => slug} =
      Regex.named_captures(~r/\/(?<date_created>\d{8})_(?<slug>.+)\.(md|livemd)$/, post_path)

    date_created = date_created_str |> Timex.parse!("{YYYY}{0M}{0D}") |> NaiveDateTime.to_date()

    %{slug: slug, date_created: date_created}
  end

  case Mix.env() do
    :dev -> defp cache_opts(), do: [ttl: 0]
    _ -> defp cache_opts(), do: [ttl: :infinity]
  end
end
