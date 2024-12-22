defmodule JsonCorpWeb.ConsultingLive do
  use JsonCorpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Consulting</.h1>
    <div class="prose">
      {consulting_markdown() |> JsonCorp.Blog.MarkdownRenderer.highlighted_html() |> raw()}
    </div>
    """
  end

  defp consulting_markdown() do
    """
    ### 기술
    #### Elixir
      - Umbrella App
      - Oban
      - [Telemetry(dispatching events for metrics)](/blog/logging_slow_queries_with_telemetry)
      - [Nebulex(cache)](/blog/cache_in_elixir_with_nebulex)
      - Broadway
      - CLDR
    #### 채용
      - 코딩 과제 다듬기
      - 채용 인터뷰
      - 채용 인터뷰 역량 개선
    #### 문화
      - 애자일
        - [애자일을 도입한다는 허상에 관하여](/blog/the_illusion_of_introducing_agile)
      - 개발 조직 미팅
      - 코드 리뷰
      - 사내 세미나
    #### 개발 개선
      - 개발환경 - 배포환경 일치
      - 테스팅
      - 의존 방향
      - 일반화
      - 일관성
      - 유연성
      - 안정성
      - 리팩토링
      - Feature Flag
      - Pagination 추상화
      - Performance 최적화
      - Finite State Machine
      - 리스크 주도 개발
    #### 테크 스택 논의
      - Javascript
        - T3 Stack
        - Vercel
        - Supabase
    #### 스터디
      - TDD - <현실 세상의 TDD: 안정감을 주는 코드 작성 방법>
      - Functional - <함수형 코딩>
    #### 세미나
      - DDD
      - X Architecture
    #### 기타
      - 단축키 교육
      - 일을 작게 쪼개서 하는 법
    ### 제품
    #### 스터디
      - 사용자 스토리 - <사용자 스토리 맵 만들기>
    #### 세미나
      - 소프트웨어를 개발하는 본질적인 간결한 방법 - <The Nature of Software Development>
      - The Right It - <아이디어 불패의 법칙>
      - 중요한 건 인터페이스야 바보야!
      - 버그 리포트 가이드
    ### 조직문화
    #### 방법론
      - OKR
    #### 성과
      - Objective, Output, Outcome
    #### 피드백
      - [CSS 상호 피드백](/blog/css_feedback)
        - [CSS 액션 아이템을 정하기 위한 1:1 미팅 가이드](/blog/css_action_item_meeting_guide)
    #### 회의
      - 회의록 작성
    #### 세미나
      - 수단과 목적 - <지적 자본론>
      - Radical Candor - <실리콘밸리의 팀장들>
    ### 리더십
    #### 독서모임
      - <네이비씰 승리의 법칙>
      - <인간관계론>
      - <하이 아웃풋 매니지먼트>
    #### 역량
      - 자기 통제
        - 극한의 오너십
        - 메타 나
        - 적당함
      - 변화를 만드는 법
        - 모든 것은 내 책임이다
        - 거쳐야 하는 과정이 있다
        - 단기, 중기, 장기
        - 오늘의 100이 내일의 80
        - [변화는 매력적이어야 한다](/blog/make_the_change_appealing)
        - 전문가의 역할
        - 탑다운 변화를 안착시키는 법
    #### 자율
      - 기둥
      - 기업과 공산주의
    ### 생산성
    #### 툴
      - GoLinks
      - Paste
    #### 세미나
      - 생각하는 나, 실행하는 나
    """
  end
end
