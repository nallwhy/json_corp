defmodule JsonCorpWeb.LiveHelpers do
  alias JsonCorp.Core.Cldr

  def ago(%DateTime{} = date_time) do
    diff_in_seconds = DateTime.diff(date_time, DateTime.utc_now())

    {:ok, relative} = Cldr.DateTime.Relative.to_string(diff_in_seconds)

    relative
  end
end
