defmodule JsonCorp.Blog.MarkdownRenderer do
  alias JsonCorp.Blog.Highlighter

  def html(markdown) do
    markdown |> Earmark.as_html!() |> Highlighter.highlight()
  end
end
