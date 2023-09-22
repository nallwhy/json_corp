defmodule JsonCorp.Schema do
  defmacro __using__([]) do
    quote do
      use Ecto.Schema
      import Ecto.Query

      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
