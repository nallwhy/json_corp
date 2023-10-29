defmodule JsonCorp.Search do
  require Logger
  alias JsonCorp.External.MeilisearchAPI
  alias JsonCorp.Internal.Meilisearch
  alias JsonCorp.Core.Puller

  def create_index(index_uid, primary_key \\ nil) do
    {:ok, %{task_uid: task_uid}} =
      MeilisearchAPI.create_index(
        %{index_uid: index_uid, primary_key: primary_key},
        meilisearch_opts()
      )

    pull_task(task_uid)
  end

  defp pull_task(task_uid) do
    pull_fun = fn -> MeilisearchAPI.get_task(%{task_uid: task_uid}, meilisearch_opts()) end
    condition_fun = fn {:ok, task} -> task.status in [:processed, :failed, :canceled] end
    wait_fun = fn retry_count -> Process.sleep(retry_count * :timer.seconds(2)) end

    Puller.pull(pull_fun, condition_fun, wait_fun)
    |> tap(fn {:ok, %{task_uid: task_uid, type: type, status: status}} ->
      Logger.debug("Task ##{task_uid} #{type} is #{status}")
    end)
  end

  defp meilisearch_opts() do
    %{host: Meilisearch.host(), api_key: Meilisearch.api_key()}
  end
end
