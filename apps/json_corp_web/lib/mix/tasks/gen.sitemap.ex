defmodule Mix.Tasks.Gen.Sitemap do
  use Mix.Task
  use JsonCorp.Blog

  @impl Mix.Task
  def run(_args) do
    url = "https://json.media"

    config = [
      store: Sitemapper.FileStore,
      store_config: [
        path: "#{:code.priv_dir(:json_corp_web)}/static"
      ],
      sitemap_url: url,
      gzip: false
    ]

    sitemaps =
      ["/", "/blog/ko", "/blog/en", "/consulting", "/playground", "/projects"]
      |> Enum.map(fn path ->
        %Sitemapper.URL{
          loc: "#{url}#{path}"
        }
      end)

    post_sitemaps =
      Blog.list_posts()
      |> Enum.map(fn %Post{language: language, slug: slug, date_created: date_created} ->
        %Sitemapper.URL{
          loc: "#{url}/blog/#{language}/#{slug}",
          changefreq: :daily,
          lastmod: date_created
        }
      end)

    (sitemaps ++ post_sitemaps)
    |> Sitemapper.generate(config)
    |> Sitemapper.persist(config)
    |> Sitemapper.ping(config)
    |> Stream.run()

    :ok
  end
end
