defmodule JsonCorp.Seq do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(key) do
    Agent.get_and_update(__MODULE__, fn %{} = map ->
      map
      |> Map.get_and_update(key, fn
        nil -> {0, 1}
        value -> {value, value + 1}
      end)
    end)
  end
end
