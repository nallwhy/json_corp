defmodule JsonCorp.Domain.Blog do
  @moduledoc """
  The Blog domain for JsonCorp.

  This domain manages blog posts and comments using the Ash framework.
  """

  use Ash.Domain

  resources do
    resource JsonCorp.Domain.Blog.Post
  end
end
