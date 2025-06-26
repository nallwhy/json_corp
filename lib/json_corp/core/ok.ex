defmodule JsonCorp.Core.Ok do
  def map({:ok, result}, fun) when is_function(fun, 1) do
    {:ok, fun.(result)}
  end

  def map(error, _fun) do
    error
  end
end
