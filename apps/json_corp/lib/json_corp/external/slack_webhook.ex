defmodule JsonCorp.External.SlackWebhook do
  def send(message) do
    Req.post!(url(), json: %{text: message})
  end

  defp url() do
    Application.get_env(:json_corp, :slack)[:webhook_url]
  end
end
