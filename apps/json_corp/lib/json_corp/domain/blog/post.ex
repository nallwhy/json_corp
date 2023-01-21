defmodule JsonCorp.Blog.Post do
  @type t :: %__MODULE__{
          title: String.t(),
          description: String.t(),
          category: String.t(),
          slug: String.t(),
          body: String.t(),
          date_created: Date.t(),
          cover_url: String.t(),
          tags: [String.t()]
        }

  @derive {Phoenix.Param, key: :slug}
  @enforce_keys [:title, :description, :category, :slug, :body, :date_created, :cover_url, :tags]
  defstruct @enforce_keys

  def is_category(%__MODULE__{category: post_category}, category) do
    post_category == category
  end
end
