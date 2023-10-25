defmodule Mix.Tasks.Gen.Rss do
  use Mix.Task
  use JsonCorp.Blog
  import XmlBuilder
  alias JsonCorp.Blog.MarkdownRenderer

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")
    host = JsonCorpWeb.Endpoint.url()
    email = "nallwhy@gmail.com (Jinkyou Son)"

    [last_post | _] =
      recent_posts =
      Blog.list_posts()
      |> Enum.take(10)

    last_modified = last_post.date_created |> date_to_datetime() |> Timex.format!("{RFC822}")

    rss =
      element(:rss, %{version: "2.0"}, [
        element(:channel, [
          element(:title, "Json Media"),
          element(:description, "Json's Playground"),
          element(:link, host),
          element(:pubDate, last_modified),
          element(:lastBuildDate, last_modified),
          element(:image, [
            element(:title, "Json Media"),
            element(:url, host <> "/images/json-logo.png"),
            element(:link, host)
          ]),
          element(:managingEditor, email),
          element(:webMaster, email),
          recent_posts |> Enum.take(10) |> Enum.map(&post_to_rss_item(&1, host))
        ])
      ])
      |> document()
      |> generate()

    File.write!("#{:code.priv_dir(:json_corp_web)}/static/feed.xml", rss)

    :ok
  end

  defp post_to_rss_item(%Post{} = post, host) do
    url = "#{host}/blog/#{post.language}/#{post.slug}"
    description = post.description <> "\n" <> MarkdownRenderer.plain_text(post.body)

    element(:item, [
      element(:title, post.title),
      element(:description, description),
      element(:link, url),
      element(:pubDate, post.date_created |> date_to_datetime() |> Timex.format!("{RFC822}")),
      element(:guid, url),
      element(:category, post.category)
    ])
  end

  defp date_to_datetime(%Date{} = date) do
    DateTime.new!(date, ~T[00:00:00])
  end
end
