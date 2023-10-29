defmodule JsonCorp.Blog.Post do
  @type t :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          description: String.t(),
          language: String.t(),
          category: String.t(),
          slug: String.t(),
          body: String.t(),
          date_created: Date.t(),
          cover_url: String.t(),
          tags: [String.t()],
          aliases: [String.t()]
        }

  @derive {Phoenix.Param, key: :slug}
  @enforce_keys [
    :id,
    :title,
    :description,
    :language,
    :category,
    :slug,
    :body,
    :date_created,
    :cover_url,
    :tags,
    :aliases
  ]
  defstruct @enforce_keys

  def is_category(%__MODULE__{category: post_category}, category) do
    post_category == category
  end

  def has_tag(%__MODULE__{tags: tags}, tag) when is_list(tags) do
    tag in tags
  end

  def has_tag(%__MODULE__{tags: nil}, _tag) do
    false
  end

  def read(post_path) do
    raw_post = post_path |> File.read!()

    %{
      language: language,
      slug_with_underscore: slug_with_underscore,
      date_created: date_created
    } = extract_meta(post_path)

    [meta_str, body] =
      raw_post
      |> String.split("---", parts: 2, trim: true)

    {meta_map, _binding} = meta_str |> Code.eval_string()

    title = meta_map |> Map.fetch!(:title)
    category = meta_map |> Map.fetch!(:category)

    default_slug = slug_with_underscore |> String.replace("_", "-")
    slug = meta_map[:slug] || default_slug

    %__MODULE__{
      id: "#{language}_#{slug}",
      title: title,
      description: meta_map[:description],
      language: language,
      category: category,
      slug: slug,
      body: body,
      date_created: date_created,
      cover_url: meta_map[:cover_url],
      tags: meta_map[:tags],
      aliases: [slug_with_underscore | meta_map[:aliases] || []] |> Enum.uniq()
    }
  end

  defp extract_meta(post_path) do
    %{"language" => language, "date_created" => date_created_str, "slug" => slug_with_underscore} =
      Regex.named_captures(
        ~r/\/(?<language>[^\/]+)\/[^\/]+\/(?<date_created>\d{8})_(?<slug>.+)\.(md|livemd)$/,
        post_path
      )

    date_created = date_created_str |> Timex.parse!("{YYYY}{0M}{0D}") |> NaiveDateTime.to_date()

    %{language: language, slug_with_underscore: slug_with_underscore, date_created: date_created}
  end
end
