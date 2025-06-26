defmodule JsonCorp.Worker.Kirin do
  use Task
  require Logger
  alias JsonCorp.External.SlackWebhook

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  def run(count \\ 0) do
    Logger.debug("Kirin is running #{count}")

    %{body: body} = Req.get!("https://kirinbrewery1.secure.force.com/WebCalender?p=Y")

    doc = Floki.parse_document!(body)

    available_dates =
      doc
      |> Floki.find(".emp a")
      |> Floki.attribute("href")
      |> Enum.map(fn url ->
        %{"m" => m_str, "d" => d_str} = Regex.named_captures(~r/m=(?<m>\d+)&d=(?<d>\d+)/, url)
        {m_str |> String.to_integer(), d_str |> String.to_integer()}
      end)

    my_available_dates =
      available_dates
      |> Enum.filter(fn {m, d} ->
        case {m, d} do
          {11, d} when d in [22, 23, 24] -> true
          _ -> false
        end
      end)

    unless my_available_dates |> Enum.empty?() do
      SlackWebhook.send("Kirin is available on #{inspect(my_available_dates)}")
    end

    count =
      case count do
        0 ->
          SlackWebhook.send("Kirin is working: #{inspect(available_dates)}")
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
