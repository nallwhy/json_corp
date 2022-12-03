defmodule JsonCorp.Schema do
  defmacro __using__([]) do
    quote do
      use Ecto.Schema
      import Ecto.Query
    end
  end
end
