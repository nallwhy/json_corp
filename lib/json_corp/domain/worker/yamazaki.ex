defmodule JsonCorp.Worker.Yamazaki do
  use Task
  require Logger
  alias JsonCorp.External.SlackWebhook

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  @url "https://reserve.suntory.co.jp/regist/switch/00051c0001CJe69uI7/courseList?date=2024-01-09"
  def run(count \\ 0) do
    Logger.debug("Yamazaki is running #{count}")

    %{body: body} = Req.get!(@url)

    doc = Floki.parse_document!(body)

    events =
      doc
      |> Floki.find(".summaryBlock h2")
      |> Floki.attribute("href")
      |> Enum.filter(fn title ->
        title =~ "ものづくり"
      end)

    unless events |> Enum.empty?() do
      SlackWebhook.send("Yamazaki is available: #{inspect(events)}")
    end

    count =
      case count do
        0 ->
          SlackWebhook.send("Yamazaki is working: #{inspect(events)}")
          count + 1

        60 ->
          0

        _ ->
          count + 1
      end

    Process.sleep(:timer.minutes(1))

    run(count)
  end
end
