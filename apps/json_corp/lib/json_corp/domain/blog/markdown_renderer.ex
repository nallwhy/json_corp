defmodule JsonCorp.Blog.MarkdownRenderer do
  alias JsonCorp.Blog.HTML

  def html(markdown) do
    extension = [
      strikethrough: true,
      table: true,
      superscript: true,
      header_ids: "post-header-",
      footnotes: true,
      multiline_block_quotes: true,
      subscript: true
    ]

    markdown
    |> MDEx.parse_document!(extension: extension)
    |> customize()
    |> MDEx.to_html!(extension: extension, render: [unsafe_: true])
  end

  # def highlighted_html(markdown) do
  #   markdown |> html() |> HTML.highlight()
  # end

  def plain_text(markdown) do
    markdown |> html() |> HTML.strip_tags()
  end

  defp customize(document) do
    use Lens2

    nodes_lens = Lens.repeatedly(Lens.key?(:nodes) |> Lens.all())

    document
    |> Deeply.update(nodes_lens, fn
      %{nodes: nodes} = node ->
        new_nodes =
          nodes
          |> Enum.flat_map(&parse_new_window_link/1)

        %{node | nodes: new_nodes}

      node ->
        node
    end)
  end

  defp parse_new_window_link(node) do
    regex = ~r/(?:\[(?<name>.*?)\])?\+\((?<link>.*?)\)/

    with %MDEx.Text{literal: literal} <- node,
         true <- Regex.match?(regex, literal) do
      Regex.split(regex, literal, include_captures: true)
      |> Enum.map(fn text ->
        case Regex.match?(regex, text) do
          true ->
            %{"name" => name, "link" => link} = Regex.named_captures(regex, text)

            name =
              case name do
                "" -> link
                _ -> name
              end

            link_html =
              ~s|<a href=#{link} target="_blank" rel="noopener noreferrer">#{name}</a>|

            %MDEx.HtmlInline{literal: link_html}

          false ->
            %MDEx.Text{literal: text}
        end
      end)
    else
      _ ->
        [node]
    end
  end
end
