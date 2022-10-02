defmodule JsonCorp.Factory do
  alias JsonCorp.Repo
  alias JsonCorp.Stats.ViewLog

  def build(factory_name, attrs \\ [])

  def build(:view_log, attrs) do
    %ViewLog{
      session_id: Ecto.UUID.generate(),
      uri: "https://json.media/blog/post0",
      created_at: DateTime.utc_now()
    }
    |> struct!(attrs)
  end

  def insert(factory_name, attrs \\ []) do
    build(factory_name, attrs)
    |> Repo.insert!()
  end
end
