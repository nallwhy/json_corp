%{
title: "Phoenix LiveView Double Mount",
category: "dev",
tags: ["Elixir", "Phoenix", "LiveView"]
}

---

https://kobrakai.de/kolumne/liveview-double-mount/

LiveView 는 HTTP request 를 받았을 때 static render 가 HTML 을 그려서 response 한다. 이를 client 에서 보여주면서 javascript 코드가 실행되어 server 와 websocket 연결이 맺어진다. 이때부터 state 변경에 따라 HTML 이 변경될 부분을 전송해서 교체하여 화면을 그린다.

LiveView 첫 연결에서 이런 double mount 는 피할 수 없다.

이 때 가장 신경쓰이는 것이 데이터를 불러오는 부분인데, 두 번의 mount 각각 데이터를 불러오게 되므로 괜히 신경이 쓰인다.

이를 해소하기 위해 HTTP 연결 때 session 에 데이터를 넣고 이를 websocket 연결에서 받도록 하는 방법, client 에서 caching 하는 방법 등을 고려해볼 수 있으나 별로 좋은 선택은 아니다.

이 글을 읽기 전까지 바보 같게도 [`assign_new/3`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#assign_new/3) 가 HTTP 연결에서 불러온 데이터를 websocket 연결에서 중복해서 불러오지 않기 위한 기능이라고 생각하고 사용하고 있었는데, plug, hook, parent LiveView 등 에서 불러온 데이터를 중복해서 assign 하지 않기 위한 용도였다. 아무 의미 없이 사용했던듯.

그동안 주로 SEO 가 중요하지 않은 backoffice 등을 LiveView 로 만들었었는데, 이런 경우는 단순히 websocket 연결인 경우, 즉 [`connected?/1`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#connected?/1) 가 `true` 인 경우 만 데이터를 불러오도록 하는 것도 방법이다.
