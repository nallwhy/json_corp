defmodule JsonCorp.Core.Nillable do
  def map(nil, _fun) do
    nil
  end

  def map(not_nil, fun) do
    fun.(not_nil)
  end

  def run(value, nil, _fun) do
    value
  end

  def run(value, _not_nil, fun) do
    fun.(value)
  end
end
