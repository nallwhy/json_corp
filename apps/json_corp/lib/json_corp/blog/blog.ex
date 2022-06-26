defmodule JsonCorp.Blog do
  alias JsonCorp.Blog.Post

  @posts_path Application.app_dir(:json_corp, "priv/posts")

  @spec list_posts :: [%Post{title: String.to(), body: String.t() | nil}]
  def list_posts(posts_path \\ @posts_path) do
    list_post_paths(posts_path)
    |> Enum.map(&read_post/1)
  end

  defp list_post_paths(posts_path) do
    posts_path
    |> File.ls!()
    |> Enum.filter(fn filename -> String.ends_with?(filename, ".md") end)
    |> Enum.sort()
    |> Enum.map(fn filename -> posts_path <> "/" <> filename end)
  end

  defp read_post(path) do
    path
    |> File.read!()
    |> parse_post()
  end

  defp parse_post(raw_post) do
    [meta_str, body] =
      raw_post
      |> String.split("---", part: 2, trim: true)

    {meta, _binding} = meta_str |> Code.eval_string()

    %Post{title: meta |> Map.get(:title), body: body}
  end
end
