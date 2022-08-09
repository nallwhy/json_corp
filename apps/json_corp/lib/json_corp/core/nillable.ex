defmodule JsonCorp.Core.Nillable do
  def map(nil, _fun) do
    nil
  end

  def map(not_nil, fun) do
    fun.(not_nil)
  end
end
