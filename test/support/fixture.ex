defmodule JsonCorp.Fixture do
  def path(relative_path) do
    "#{__DIR__}/../fixtures/" <> relative_path
  end
end
