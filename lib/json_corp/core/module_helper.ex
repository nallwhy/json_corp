defmodule JsonCorp.Core.ModuleHelper do
  def to_string(module) do
    module
    |> Module.split()
    |> Enum.join(".")
  end
end
