defmodule JsonCorp.Blog do
  alias JsonCorp.Blog.Post

  @posts_path Application.app_dir(:json_corp, "priv/posts")

  @spec list_posts() :: [Post.t()]
  def list_posts(posts_path \\ @posts_path) do
    list_post_paths(posts_path)
    |> Enum.map(&read_post(&1, posts_path))
  end

  @spec fetch_post(slug :: String.t()) :: {:ok, %Post{}} | :error
  def fetch_post(slug, posts_path \\ @posts_path) do
    list_post_paths(posts_path)
    |> find_by_slug(slug)
    |> case do
      filename when not is_nil(filename) -> {:ok, read_post(filename, posts_path)}
      nil -> :error
    end
  end

  defp list_post_paths(posts_path) do
    posts_path
    |> File.ls!()
    |> Enum.filter(fn filename -> String.ends_with?(filename, ".md") end)
    |> Enum.sort()
  end

  defp find_by_slug(filenames, slug) do
    filenames
    |> Enum.find(&(extract_meta_from_filename(&1).slug == slug))
  end

  defp read_post(filename, posts_path) do
    meta_from_filename = extract_meta_from_filename(filename)

    (posts_path <> "/" <> filename)
    |> File.read!()
    |> parse_post(meta_from_filename)
  end

  defp parse_post(raw_post, %{slug: slug}) do
    [meta_str, body] =
      raw_post
      |> String.split("---", part: 2, trim: true)

    {meta_map, _binding} = meta_str |> Code.eval_string()

    title = meta_map |> Map.fetch!(:title)

    %Post{slug: slug, title: title, body: body}
  end

  defp extract_meta_from_filename(filename) do
    %{"slug" => slug} = Regex.named_captures(~r/\d{6}_(?<slug>.+)\.md$/, filename)

    %{slug: slug}
  end
end
