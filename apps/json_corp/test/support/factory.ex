defmodule JsonCorp.Factory do
  alias JsonCorp.Repo
  alias JsonCorp.Blog.SecretPost
  alias JsonCorp.Stats.ViewLog
  alias JsonCorp.Seq

  def build(factory_name, attrs \\ [])

  def build(:secret_post, attrs) do
    %SecretPost{
      title: seq_s(:secret_post_title),
      description: seq_s(:secret_post_description),
      category: seq_s(:secret_post_category),
      slug: seq_s(:secret_post_slug),
      body: seq_s(:secret_post_body),
      date_created: Date.utc_today(),
      cover_url: seq_s(:secret_post_cover_url),
      password: seq_s(:secret_post_password)
    }
    |> struct!(attrs)
  end

  def build(:view_log, attrs) do
    %ViewLog{
      session_id: UUID.uuid4(),
      uri: "https://json.media/blog/post0",
      created_at: DateTime.utc_now()
    }
    |> struct!(attrs)
  end

  def insert(factory_name, attrs \\ []) do
    build(factory_name, attrs)
    |> Repo.insert!()
  end

  defp seq_s(key) do
    "#{key}-#{seq(key)}"
  end

  # defp seq(key, fun) do
  #   seq(key) |> fun.()
  # end

  defp seq(key) do
    Seq.get(key)
  end
end
