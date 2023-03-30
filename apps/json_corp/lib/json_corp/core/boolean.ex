defmodule JsonCorp.Core.Boolean do
  def run(value, false, _fun) do
    value
  end

  def run(value, true, fun) do
    fun.(value)
  end
end
