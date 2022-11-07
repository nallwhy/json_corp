defmodule JsonCorp.Factory do
  alias JsonCorp.Repo
  alias JsonCorp.Stats.ViewLog
  alias JsonCorp.Seq

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
