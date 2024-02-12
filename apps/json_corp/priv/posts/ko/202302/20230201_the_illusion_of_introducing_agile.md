%{
title: "애자일을 도입한다는 허상에 관하여",
description: "도입이 아니라 추구하기",
category: :dev,
cover_url: "/images/blog/20230201_success_or_failure.png",
tags: ["개발", "애자일", "정도", "추구"]
}

---

컨설팅을 하던 중 Git branch 들이 너무 오래 살아있다가 trunk 로 들어오고, 그래서 나중에 merge 가 힘들어지거나 배포가 막히는 등의 문제가 발생하고 있는 것을 발견했다.

그래서 [Trunk-based Development](https://trunkbaseddevelopment.com/) 에 대해 설명하는 세션을 가졌는데, 이 때 아래와 같은 이야기가 나왔다.

"이전에 있던 조직에서 Trunk-based Development 를 시도해봤었는데 실패했고, 주변에 다른 조직들 얘기를 들었을 떄도 성공한 케이스를 들어보지 못했다. Trunk-based Development 이 이상적으로 좋다는 것은 알지만 이를 도입하는 것은 우려된다."\
(그 분이 계셨던 조직은 우리나라에서 굉장히 개발을 잘한다고 평가받는 조직이라, 실력이 없어서 실패한 것은 아니라고 생각해도 될 듯 하다)

<figure>
  <img src="/images/blog/20230201_trunk_based_development.svg" alt="Trunk-based Development">
  <figcaption>Trunk-based Development(https://cloud.google.com/architecture/devops/devops-tech-trunk-based-development)</figcaption>
</figure>

그 때 당장은 주변에 Trunk-based Development 를 잘 수행하고 있는 조직에 있는 지인들이 있어서 꼭 실패하는 것은 아니라고 얘기했지만, 나중에 곰곰히 생각하고나니 **'Trunk-based Development 를 실패한다는 것은 무엇인가?'** 라는 고민이 들었다.

---

10년 전 내가 있던 조직은 3D Printing 를 위한 Windows Desktop Application 을 개발하는 곳이었고, 1년에 한 번 정도 제품을 배포하고 있었다.

이 때 IT 회사들 사이에 '애자일' 이라는 것에 대해 이야기가 돌기 시작했고, 당연하게도 애자일을 **도입** 했다가 실패한 이야기도 함께 유행했었다.\
(그래서 당시에는 애자일 한다고 하는 조직은 오히려 개발자들에게 겉멋들었다고 비웃음의 대상이 되거나, 그런 회사는 피해야 한다는 이야기도 농담처럼 돌았다. 요즘으로 하면 뭐랑 비슷할까? 저희는 TDD 를 합니다 정도?)

그 때 당시 우리 조직도 "워터폴을 벗어나서 애자일을 도입하자!" 라고 하며 스크럼 마스터를 정하고, 2주 단위의 스프린트를 돌리고, 매일 아침 스크럼을 진행했었다.\
이 애자일은 성공했을까? 실패했을까?

그리고 10년이 지난 지금 우리는 지금 다들 **애자일하게 일한다**고 한다.\
그러면 우리는 이제 애자일을 성공한 것일까?

<figure>
  <img src="/images/blog/20230201_success_or_failure.png" alt="Success or Failure">
  <figcaption>성공? 실패?</figcaption>
</figure>

---

애자일은 도입하는 것이 아니다.\
따라서 성공하거나 실패하는 것도 아니다.

워터폴로 일한다는 곳도 전혀 애자일하지 않은 것이 아닐테고(한 번 기획하고 나면 완성할 때까지 절대 수정안하는 조직이 과연 있을까?)\
애자일하게 일한다는 곳도 완전히 애자일한 것은 아닐테다.

<figure>
  <img src="/images/blog/20230201_scale.png" alt="Scale">
  <figcaption>정도의 문제</figcaption>
</figure>

> 공정과 도구보다 개인과 상호작용을\
> 포괄적인 문서보다 작동하는 소프트웨어를\
> 계약 협상보다 고객과의 협력을\
> 계획을 따르기보다 변화에 대응하기를\
> 가치 있게 여긴다.
>
> - [애자일 소프트웨어 개발 선언](https://agilemanifesto.org/iso/ko/manifesto.html)

애자일은 성공/실패의 문제가 아니라 **정도**의 문제이다.\
따라서 애자일은 도입하는 것이 아니라 **추구**하는 것이다.

추구한다는 것은 성공을 위한 n번의 시도가 아니라 Sweet Spot 을 찾는 끝나지 않는 과정이다.

즉, 우리는 애자일에 성공하는 것이 아니라 애자일하게 일하는 것을 추구하고 끊임 없이 그 정도를 조정해나가는 것이다.

---

다시 Trunk-based Development 로 돌아오면, 이도 마찬가지다.

Trunk-based Development 는 도입하는 것이 아니라 추구하는 것이다.\
활성화된 branch 를 줄이고, code freeze 기간을 줄이고, PR approve 까지 걸리는 시간을 줄이고, trunk 에 더 자주 merge 하고

하지만 많은 곳들은 이를 **도입**하려고 한다.\
그러면 어떻게 될까?

모든 branch 는 자식 branch 를 만들지 말고 바로 trunk 에 merge 하시오.\
모든 branch 는 3일 안에 merge 하시오.\
이를 지키지 않으면 Trunk-based Development 를 위반하는 것입니다.

그러면 당연히 **실패**한다.\
그리고 "Trunk-based Development 는 이상적이야. 실제로 해보면 잘 안돼." 라고 한다.

하지만 지금 대부분의 조직은 10년 전보다 훨씬 더 Trunk-based 하게 개발하고 있다.\
10년 전에는 SVN 으로 branch 도 어쩌다 만들고 늘 merge conflict 에 고통받으며 빌드는 툭하면 깨졌었다.

당신 조직의 Trunk-based Development 는 실패했는가?
