defmodule JsonCorp.Blog do
  use Nebulex.Caching
  alias JsonCorp.Blog.Post
  alias JsonCorp.Core.Cache

  @posts_path Application.app_dir(:json_corp, "priv/posts")

  @decorate cacheable(cache: Cache)
  @spec list_posts() :: [Post.t()]
  def list_posts(posts_path \\ @posts_path) do
    list_post_paths(posts_path)
    |> Enum.map(&read_post(&1, posts_path))
    |> Enum.sort_by(fn %Post{date: date} -> date end, :desc)
  end

  @decorate cacheable(cache: Cache, key: slug, match: &Cache.default_matcher/1)
  @spec fetch_post(slug :: String.t()) :: {:ok, %Post{}} | :error
  def fetch_post(slug, posts_path \\ @posts_path) do
    list_posts(posts_path)
    |> Enum.find(fn %Post{slug: post_slug} -> post_slug == slug end)
    |> case do
      %Post{} = post -> {:ok, post}
      nil -> :error
    end
  end

  @spec list_categories() :: [atom()]
  def list_categories() do
    [:talk, :dev, :consulting]
  end

  defp list_post_paths(posts_path) do
    posts_path
    |> File.ls!()
    |> Enum.filter(fn filename -> String.ends_with?(filename, ".md") end)
    |> Enum.sort()
  end

  defp read_post(filename, posts_path) do
    meta_from_filename = extract_meta_from_filename(filename)

    (posts_path <> "/" <> filename)
    |> File.read!()
    |> parse_post(meta_from_filename)
  end

  defp parse_post(raw_post, %{slug: slug, date: date}) do
    [meta_str, body] =
      raw_post
      |> String.split("---", part: 2, trim: true)

    {meta_map, _binding} = meta_str |> Code.eval_string()

    title = meta_map |> Map.fetch!(:title)
    category = meta_map |> Map.fetch!(:category)

    %Post{title: title, category: category, slug: slug, body: body, date: date}
  end

  defp extract_meta_from_filename(filename) do
    %{"date" => date_str, "slug" => slug} =
      Regex.named_captures(~r/(?<date>\d{8})_(?<slug>.+)\.md$/, filename)

    date = date_str |> Timex.parse!("{YYYY}{0M}{0D}")

    %{slug: slug, date: date}
  end
end
