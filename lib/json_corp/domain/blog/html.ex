defmodule JsonCorp.Blog.HTML do
  alias JsonCorp.Blog.Highlighter

  @clean_html_regex ~r/<(?:[^>=]|='[^']*'|="[^"]*"|=[^'"][^\s>]*)*>/

  @doc """
  Strips html tags from text leaving their text content

  Copied from ex_doc ExDoc.Formatter.HTML
  """
  def strip_tags(text, replace_with \\ "") when is_binary(text) do
    String.replace(text, @clean_html_regex, replace_with)
  end

  def highlight(html) do
    html |> Highlighter.highlight()
  end
end
