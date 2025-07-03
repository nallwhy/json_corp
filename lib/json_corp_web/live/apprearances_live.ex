defmodule JsonCorpWeb.AppearancesLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(talks: talks(), publications: publications())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>{gettext("appearances") |> String.capitalize()}</.h1>

    <div class="space-y-12">
      <div>
        <.h2>{gettext("talks") |> String.capitalize()}</.h2>
        <div class="flex flex-wrap gap-6">
          <.card :for={talk <- @talks} title={talk.title}>
            <p>{talk.description}</p>
            <:actions>
              <.link href={talk.url} class="btn btn-primary" target="_blank">Open</.link>
            </:actions>
          </.card>
        </div>
      </div>

      <div>
        <.h2>{gettext("publications") |> String.capitalize()}</.h2>
        <div class="flex flex-wrap gap-6">
          <.card :for={publication <- @publications} title={publication.title}>
            <p>{publication.description}</p>
            <:actions>
              <.link href={publication.url} class="btn btn-primary" target="_blank">Open</.link>
            </:actions>
          </.card>
        </div>
      </div>
    </div>
    """
  end

  defp talks() do
    [
      %{
        title: "Ash - Declarative Design Framework",
        description: "liftIO 2024",
        url: "https://www.youtube.com/watch?v=S-WNIhcp5tM,"
      },
      %{
        title: "How Easy is Implementing Multi-Tenancy in Ecto?",
        description: "ElixirConf US 2023 - Lightning Talk",
        url: "https://www.youtube.com/watch?v=lyXIp7akK8A&t=466s"
      },
      %{
        title: "중요한 건 인터페이스야, 바보야!",
        description: "2023 두번째 개취콘, 백엔드 개발자 이야기 JUMPIT TO BACK - END",
        url: "https://www.youtube.com/live/qI4zF0GfEW0?si=cF499AJvLGL1BG6_&t=945"
      }
    ]
  end

  defp publications() do
    [
      %{
        title: "개발자의 사이드 프로젝트",
        description: "원티드 - <이 시대의 개발자로 일하기> 시리즈",
        url: "https://www.wanted.co.kr/events/21_12_s01_b02"
      },
      %{
        title: "엉덩이가 무거워진 개발자의 딜레마",
        description: "원티드 - <이 시대의 개발자로 일하기> 시리즈",
        url: "https://www.wanted.co.kr/events/22_02_s09_b01"
      },
      %{
        title: "빨리 적응하는 개발자의 특징",
        description: "원티드 - <이 시대의 개발자로 일하기> 시리즈",
        url: "https://www.wanted.co.kr/events/22_03_s07_b03"
      },
      %{
        title: "개발자 대란을 이겨내는 스타트업 채용 전략",
        description: "원티드 - <이 시대의 개발자로 일하기> 시리즈",
        url: "https://www.wanted.co.kr/events/22_05_s01_b01"
      }
    ]
  end
end
