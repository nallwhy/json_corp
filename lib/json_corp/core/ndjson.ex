defmodule JsonCorp.Core.NDJSON do
  def encode(list) do
    list
    |> Enum.map(&(&1 |> Jason.encode!()))
    |> Enum.join("\n")
  end

  def decode(string) do
    string
    |> String.split("\n")
    |> Enum.map(&(&1 |> Jason.decode!()))
  end
end
