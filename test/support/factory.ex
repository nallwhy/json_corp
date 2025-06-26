defmodule JsonCorp.Factory do
  use JsonCorp.Blog
  alias JsonCorp.Stats.ViewLog
  alias JsonCorp.Repo
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

  def build(:comment, attrs) do
    {status, attrs} = attrs |> Map.pop(:status, :pending)

    %Comment{
      post_slug: seq_s(:comment_post_slug),
      session_id: build(:uuid),
      name: seq_s(:comment_name),
      email: seq_s(:comment_email),
      body: seq_s(:comment_body)
    }
    |> apply_comment_status(status, attrs)
    |> struct!(attrs)
  end

  def build(:view_log, attrs) do
    %ViewLog{
      session_id: build(:uuid),
      uri: "https://json.media/blog/post0",
      created_at: DateTime.utc_now()
    }
    |> struct!(attrs)
  end

  def build(:uuid, _) do
    UUID.uuid4()
  end

  def insert(factory_name, attrs \\ []) do
    build(factory_name, Map.new(attrs))
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

  defp apply_comment_status(%Comment{} = comment, :pending, _attrs) do
    comment
  end

  defp apply_comment_status(%Comment{} = comment, :confirmed, attrs) do
    comment
    |> apply_comment_status(:pending, attrs)
    |> Map.put(:confirmed_at, DateTime.utc_now())
  end
end
