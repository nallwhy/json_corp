%{
title: "OpenAI Davinci 모델 Fine-tuning 하기 - (1)",
description: "지인의 말투를 학습한 챗봇 만들기",
cover_url: "/images/blog/20230301_cover.png",
category: "dev",
tags: ["개발", "AI", "OpenAI", "Fine-tuning", "Davinch", "챗봇", "ChatGPT"],
}

---

[OpenAI](https://openai.com/) 에서는 자신들이 제공하는 AI 모델들을 Fine-tuning 해서 자신만의 AI 모델을 만들어 사용할 수 있는 기능을 제공한다.

어떤 것을 해볼까 고민하다가, 지인과의 카카오톡 대화 기록을 이용하여 지인과 비슷하게 대답해주는 챗봇을 만들어보면 재밌겠다고 생각했다.

아직까지는 좋은 결과를 못얻었지만 과정 중에 학습한 것들을 기록해두기 위해 일단 정리!

## Fine-tune 하기

### [OpenAI 모델](https://platform.openai.com/docs/models)

OpenAI 에서는 여러가지 모델을 제공한다.

- [`GPT-3`](https://platform.openai.com/docs/models/gpt-3): 자연어를 이해하고 생성할 수 있는 모델. [`ChatGPT`](https://openai.com/blog/chatgpt) 를 생각하면 된다.
- [`Codex`](https://platform.openai.com/docs/models/codex): 코드를 이해하고 생성할 수 있는 모델. [`GitHub Copilot`](https://github.com/features/copilot) 을 생각하면 된다.
- [`Content filter`](https://platform.openai.com/docs/models/content-filter): 텍스트의 민감성, 위험성을 감지할 수 있는 모델. 별도의 [Moderation](https://platform.openai.com/docs/guides/moderation) 기능이 제공되면서 이제 사용할 일 없음.

챗봇을 만든다면 자연어를 이해하고 생성할 수 있는 `GPT-3` 모델이 적합하다.

`GPT-3` 에는 다시 여러 모델들이 있는데 그 중 `ChatGPT` 와 같거나 매우 흡사하다고 여겨지는 것은 [`text-davinci-003`](https://platform.openai.com/docs/models/gpt-3) 모델이다.\
하지만 `text-davinci-003` 같이 이미 별도의 학습을 거친 모델은 우리가 Fine-tuning 할 수 없고, 그 모델의 모태인 `Davinci`, `Curie` 등의 모델을 Fine-tuning 해서 새로운 모델을 만들 수 있다.

그래서 이번 작업에서는 `Davinci` 모델을 사용해서 Fine-tuning 을 진행한다.\
(비용은 가장 고성능인 `Davinci` 모델이 제일 비싸다. 가장 저렴한 `Ada` 모델과는 token 당 75배의 가격 차이가 난다. 따라서 더 간단한 목적의 AI 모델을 원한다면 `Davinci` 대신 다른 모델을 고려해볼 필요가 있다.)

### Fine-tune 데이터셋

Fine-tuning 을 위해서는 `prompt-completion` 쌍으로 이루어진 데이터들이 [JSONL](https://jsonlines.org/) 형태로 제공되어야 한다.

예시: https://platform.openai.com/docs/guides/fine-tuning/prepare-training-data

```jsonl
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
...
```

JSONL 은 한 줄마다 하나의 JSON 값이 들어간 형태이기 때문에, 기존의 JSON 과 다르게 streaming 으로 한 줄씩 받아 decoding 하여 처리할 수 있다.\
(JSON 은 어디서 하나의 값이 완료될지 모르기 때문에, 일반적으로 전체를 다 받아야만 decoding 이 가능하다.)

예시: https://jsonlines.org/examples/

```jsonl
{"name": "Gilbert", "wins": [["straight", "7♣"], ["one pair", "10♥"]]}
{"name": "Alexa", "wins": [["two pair", "4♠"], ["two pair", "9♠"]]}
{"name": "May", "wins": []}
{"name": "Deloise", "wins": [["three of a kind", "5♣"]]}
```

JSON - JSONL 간의 변환은 `jq` 를 이용해서도 간단하게 할 수 있다.

```
# JSON -> JSONL

jq -c '.[]' input.json > output.jsonl

# JSONL -> JSON

jq -s '.' input.jsonl > output.json
```

Reference: https://gist.github.com/sloanlance/c3bf746b6396f60d321f5535e1ced892

카카오톡 대화는 text 로 받으면 아래와 같은 형식의 CSV 로 되어있다.

```csv
Date,User,Message
2022-12-17 13:55:24,"Json","하이"
2022-12-17 13:55:27,"Json","뭐함"
2022-12-17 14:28:23,"Csv","ㅋㅋㅋㅋㅋㅋㅋㅋ 밥먹음"
2022-12-17 14:28:30,"Csv","왜"
```

한 사람에게서 이어지는 대화는 하나로 묶는 것이 좋겠다고 생각했고, prompt 로 내 대화를, completion 으로 상대의 대화를 넣으면 되지 않을까 생각했다.\
각 대화는 `\n` 로 묶었다.

```jsonl
{"prompt": "하이\n뭐함", "completion": "ㅋㅋㅋㅋㅋㅋㅋㅋ 밥먹음\n왜"}
...
```

후술하겠지만 데이터셋을 이렇게 만든 것은 `ChatGPT` 같은 GPT 모델에 대한 나의 몰이해로 인한 것이었다.

### [Fine-tune 비용](https://openai.com/api/pricing/)

`Davinci` 모델의 비용은 아래와 같다.

- Training: $0.0300 / 1K tokens
- Usage: $0.1200 / 1K tokens

영어는 4 글자당 1 token, 한글은 1 글자당 2 token 정도 한다. (shit!)

이번에 사용한 데이터는 대략 51만 token, 비용은 $30 정도로 예상되었다.\
(프로그래밍 언어로 Elixir 를 사용했는데, Elixir 에는 아직 token calculator 구현이 없어서 근사로만 구했다.)

### [Fine-tune 과정](https://platform.openai.com/docs/guides/fine-tuning)

#### 데이터셋 업로드

[Upload file](https://platform.openai.com/docs/api-reference/files/upload) API 를 사용해 데이터셋을 업로드 한다.

Request body 의 `purpose` 에 `"fine-tune"` 을 넣으면 validation 을 해준다.

Response body 의 `id` 를 Fine-tune 생성 할 때 넣을 것이다.

Response body example:

```json
{
  "id": "file-XjGxS3KTG0uNmNOK362iJua3",
  "object": "file",
  "bytes": 140,
  "created_at": 1613779121,
  "filename": "mydata.jsonl",
  "purpose": "fine-tune"
}
```

#### Fine-tune 생성

[Create fine-tune](https://platform.openai.com/docs/api-reference/fine-tunes/create) API 를 사용해 기존에 만든 데이터셋을 기반으로 Fine-tune 을 생성할 것이다.

Request body 의 `training_file` 에 위에서 얻은 file id 를, `model` 에 `"davinci"` 를 넣으면 기본적인 요소는 충족한다.\
나머지는더 정교한 Fine-tuning 을 위한 값들이다.

Response body 의 `id` 가 생성된 Fine-tune id 인데, 이것이 생성된 모델의 id 는 아니다.\
Fine-tune 은 오래 걸리는 작업이기 때문에, 이 Fine-tune id 를 이용해서 작업의 진행 상황을 계속해서 확인할 수 있고, 작업이 완료되면 `fine_tuned_model` 값으로 생성된 모델의 id 를 얻을 수 있다.

Response body example:

```json
{
  "id": "ft-AF1WoRqd3aJAHsqc9NY7iL8F",
  "object": "fine-tune",
  "model": "curie",
  "created_at": 1614807352,
  "events": [
    {
      "object": "fine-tune-event",
      "created_at": 1614807352,
      "level": "info",
      "message": "Job enqueued. Waiting for jobs ahead to complete. Queue number: 0."
    }
  ],
  "fine_tuned_model": null,
  "hyperparams": {
    "batch_size": 4,
    "learning_rate_multiplier": 0.1,
    "n_epochs": 4,
    "prompt_loss_weight": 0.1
  },
  "organization_id": "org-...",
  "result_files": [],
  "status": "pending",
  "validation_files": [],
  "training_files": [
    {
      "id": "file-XGinujblHPwGLSztz8cPS8XY",
      "object": "file",
      "bytes": 1547276,
      "created_at": 1610062281,
      "filename": "my-data-train.jsonl",
      "purpose": "fine-tune-train"
    }
  ],
  "updated_at": 1614807352
}
```

#### Fine-tune 진행 상황 확인

[Retrieve fine-tune](https://platform.openai.com/docs/api-reference/fine-tunes/retrieve) API 로 Fine-tune 의 진행 상황을 확인할 수 있다.

위에서 언급한 Create Fine-tune API 와 response body 형태가 같다.\
Response body 의 `status` 가 `succeeded` 가 되면 Fine-tune 이 성공한 것으로, `fine_tuned_model` 로부터 모델 id 를 얻을 수 있다.\
도중에 여러가지 이유로 Fine-tune 이 실패한 경우 Response body 의 `status` 는 `failed` 가 되고, `events` 의 기록을 통해 어느 단계에서 어떤 이유로 실패했는지 알 수 있다.

### Fine-tune 된 모델 사용하기

Fine-tune 된 모델은 간단하게는 [OpenAI Playground](https://platform.openai.com/playground) 에서 사용해 볼 수 있다.

아래와 같이 [Model] - [Show more models] - [Fine-tune 된 모델] 을 선택하여 prompt 를 쓰면 completion 을 해준다.

<figure>
  <img src="/images/blog/20230301_openai_playground_1.png" alt="OpenAI Playground 모델 선택 1">
  <figcaption>[Model] 에서 [Show more models] 를 누르면</figcaption>
</figure>

<figure>
  <img src="/images/blog/20230301_openai_playground_2.png" alt="OpenAI Playground 모델 선택 2">
  <figcaption>내가 Fine-tune 한 모델이 보인다!</figcaption>
</figure>

<figure>
  <img src="/images/blog/20230301_openai_playground_3.png" alt="OpenAI Playground 모델 사용">
  <figcaption>평소에 명상을 좋아하는 지인의 성향이 반영된듯</figcaption>
</figure>

이를 [Create completion](https://platform.openai.com/docs/api-reference/completions/create) API 를 통해 호출해서도 사용할 수 있다.

Request body 의 `model` 에 모델 id 와 `prompt` 에 원하는 prompt 를 입력하면 기본적인 요소는 충족한다.\
과도한 비용 청구를 막기 위해 `max_tokens` 를 조정할 수 있는데, 기본값이 16 이어서 큰 걱정은 안해도 된다.

Response body 에서 `choices` 에 completion 들이 담겨서 온다.

## 회고

어느 정도 지인의 말투가 녹아든 모델이 만들어지기는 했지만, 제대로 된 대화가 될 수 있는 수준은 아니었다.

이런 결과가 만들어진 이유에 대해서 회고해보았다.

데이터셋에서 prompt 에 내 대화를, completion 에 상대의 대화를 넣은 것은 GPT 모델에 대한 몰이해 때문이었다.

평소에 `GPT` 에 대해서 얘기할 때마다 'GPT 는 다음에 올 적절한 말을 찾아서 이어나가는 AI' 라고 하고 다녔지만, 막상 `ChatGPT` 를 사용하다 보니 `GPT` 가 작동하는 방식을 '질문-답변' 구조로 착각하게 되었다.

`GPT` 는 text-completion 을 목적으로 한다.\
즉, `GPT` 입장에서는 질문과 답변이라는 개념이 없다. 단지 다음에 올 적절한 말을 찾을 뿐이다.

그래서 OpenAI 의 [Fine-tuning Preparing your dataset](https://platform.openai.com/docs/guides/fine-tuning/preparing-your-dataset) 를 보면 prompt 를 넣을 때 마지막에 separator 를, completion 을 넣을 때 stop sequence 를 넣는 것을 권장하고 있다.

그리고 [Text completion - Conversation](https://platform.openai.com/docs/guides/completion/conversation) 을 보면 prompt 를 아래와 같이 대화형으로 작성하는 예제가 있다.

```
The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.

Human: Hello, who are you?
AI: I am an AI created by OpenAI. How can I help you today?
Human:
```

즉, 대화형 prompt 에 이어지는 대화형 completion 을 학습시켜야 대화를 할 수 있는 (정확하게는 대화처럼 생긴 글에 뒤를 이어나갈 수 있는) 모델이 생성될 것이다.

다음 번 작업에서는 다른 사람들이 작업한 과정들을 좀 더 확인해보고, 데이터 전처리를 위의 예제 같이 변경해서 작업해볼 예정이다.

---

Cover Image: generated by Midjourney with prompt 'Openai chatbot logo simple cool'
