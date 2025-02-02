defmodule JsonCorp.Blog.MarkdownRenderer do
  alias JsonCorp.Blog.HTML

  def html(markdown) do
    markdown
    |> MDEx.parse_document!(
      extension: [
        footnotes: true
      ]
    )
    |> MDEx.to_html!(render: [unsafe_: true])
  end

  # def highlighted_html(markdown) do
  #   markdown |> html() |> HTML.highlight()
  # end

  def plain_text(markdown) do
    markdown |> html() |> HTML.strip_tags()
  end
end
