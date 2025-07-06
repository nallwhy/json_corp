defmodule JsonCorp.Domain.Blog.Post do
  use Ash.Resource, domain: JsonCorp.Domain.Blog

  attributes do
    attribute :id, :string, primary_key?: true, allow_nil?: false
    attribute :title, :string, allow_nil?: false
    attribute :description, :string
    attribute :language, :string, allow_nil?: false
    attribute :category, :string, allow_nil?: false
    attribute :slug, :string, allow_nil?: false
    attribute :body, :string, allow_nil?: false
    attribute :date_created, :date, allow_nil?: false
    attribute :cover_url, :string
    attribute :tags, {:array, :string}, default: []
    attribute :aliases, {:array, :string}, default: []
    attribute :status, :atom, constraints: [one_of: [:published, :deleted]], default: :published
  end
end
