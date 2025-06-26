defmodule JsonCorp.Core.Calendar do
  # https://github.com/lau/calendar/blob/c910efc8ca5088dc401e367c1fac81748d13f671/lib/calendar/date_time/format.ex

  def format(%DateTime{} = datetime) do
    format(datetime, :iso8601)
  end

  def format(%DateTime{} = datetime, :iso8601) do
    datetime |> DateTime.to_iso8601()
  end

  def format(%DateTime{} = datetime, :iso8601_basic) do
    datetime |> DateTime.to_iso8601(:basic)
  end

  def format(%DateTime{} = datetime, :rfc822) do
    format(datetime, "%a, %d %b %y %X %z")
  end

  def format(%DateTime{} = datetime, format) when is_binary(format) do
    datetime |> Calendar.strftime(format)
  end

  def parse_date!(str, :iso8601_basic) do
    parse_date!(str, "%Y%m%d")
  end

  def parse_date!(str, format) do
    str |> Datix.Date.parse!(format)
  end
end
