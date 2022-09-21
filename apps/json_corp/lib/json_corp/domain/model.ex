defmodule JsonCorp.Model do
  defmacro __using__([]) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
    end
  end
end
