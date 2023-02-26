%{
title: "reflow 리뉴얼",
description: "다시 시작",
cover_url: "/images/blog/20230215_cover.png",
category: "business",
tags: ["reflow", "사업"]
}

---

[reflow](https://reflow.work) 를 리뉴얼했다.

reflow 는 데이터 보는 습관을 만드는 가장 쉬운 툴을 목표로, 현재는 데이터를 보는 허들을 낮추기 위해 데이터를 주기적으로 레포트화 시켜서 슬랙으로 전송해주는 서비스를 제공하고 있다.

### 리뉴얼을 한 이유

2022-11-28 에 오픈 베타를 시작했을 때 생각보다 전환율이 높지 않았다.\
특히 제품을 직접적으로 사용해보기도 전에 이탈이 많아서, 랜딩 페이지가 충분히 서비스를 설명하고 있지 못하다고 생각했다.

기존의 랜딩 페이지는 적은 리소스로 빠르게 만들기 위해 [WebFlow](https://webflow.com/) 를 사용했는데, 생각보다 쉽지 않아서 디테일한 부분을 신경쓰기 어려웠고 비용도 적지 않아서 만족스럽지 않았다.\
다음에 노코드 툴로 랜딩 페이지를 만든다면, [Usmo](https://www.umso.com/) 를 사용해볼 예정.

그리고 지난 오픈 베타 오픈 때 인바운드로 [Google BigQuery](https://cloud.google.com/bigquery) 를 데이터 소스로 등록할 수 있게 해달라는 요청이 여러 건 들어왔는데, 초기 서비스에 무려 인바운드로 요청이 들어온다는 것은 실제로는 이에 대한 더 많은 니즈가 있다고 가정할 수 있는 부분이라고 생각했다.

그래서 Google BigQuery 데이터 소스 지원을 추가했고, 리뉴얼을 통해 이를 좀 더 홍보하면 좋겠다고 생각했다.

### 무엇이 좋아졌는가

이번에는 [워니](https://www.facebook.com/hee072794) 가 랜딩 페이지를 직접 만들었다.\
감각이 좋아서 랜딩 페이지를 디자인부터 개발까지 빠르게 다 해주었고, 이번에는 랜딩 페이지가 보기 좋다는 피드백도 여럿 받았다.\
이전보다 우리가 어떤 서비스를 제공하는지, 왜 쓰면 좋은지를 제공하려고 했다.\
그래서 전환율도 이전 오픈 베타보다 훨씬 높아졌다. 성공!

그리고 Google BigQuery 를 데이터 소스로 지원하고 이를 기존에 요청해주셨던 고객 분들에게 안내드렸더니, 모두 전환해주셨다.\
엄청난 효과!

### 무엇을 배웠는가

- 사용자가 우리 서비스를 실제로 쓰게 만들려면, 이것을 왜 써야 하는지 제대로 전달해야 한다. 제품을 알고 있는 우리야 당연히 쓰겠지라고 생각하지만 이 제품이 무엇인지 알 수 없는 사용자에게는 어림 없는 소리.
- 인바운드 요청은 매우 강력하고 보기보다 더 규모가 클 수 있는 니즈라는 가설을 확인.

### 앞으로의 계획

- 사용자가 랜딩 페이지에서 우리 제품을 더 잘 파악할 수 있게 하고 싶다. 그래서 [Arcade](https://app.arcade.software/) 를 사용해볼 예정.
- [AWS Athena](https://aws.amazon.com/athena/), [AWS Redshift](https://aws.amazon.com/redshift/) 도 데이터 소스로 요청이 들어와서 빠르게 대응해야겠다.
- Email, [Google Chat](https://chat.google.com) 이 레포트 타겟으로 연동 요청이 들어왔다. 이 부분도 위와 마찬가지.
- B2B SaaS 는 사용자를 위해 문서화가 잘 되어있어야겠다는 생각이 들었다. 서비스는 복잡하고, 홈페이지에 모든 설명을 넣기에는 공간이 부족하다. 현재는 [Nextra](https://nextra.site) 를 이용해 구축하는 것을 고려 중.
- 블로그도 마찬가지. Use case 를 많이 보여줘야 사용하고 싶은 마음이 더 들텐데, 홈페이지는 이런 것을 다 넣기에는 좁다. [Storyblok](https://www.storyblok.com/) 을 이용해 backend 를 구축하고 현재 홈페이지에서 불러와 사용하는 것을 고려 중.