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

  def delete_index(index_uid) do
    {:ok, %{task_uid: task_uid}} =
      MeilisearchAPI.delete_index(%{index_uid: index_uid}, meilisearch_opts())

    pull_task(task_uid)
  end

  def upsert_documents(index_uid, documents) do
    {:ok, %{task_uid: task_uid}} =
      MeilisearchAPI.add_or_replace_documents(
        %{index_uid: index_uid, documents: documents},
        meilisearch_opts()
      )

    pull_task(task_uid)
  end

  def search(index_uid, query, pagination \\ %{offset: 0, limit: 20}) do
    MeilisearchAPI.search(%{index_uid: index_uid, q: query}, pagination, meilisearch_opts())
  end

  defp pull_task(task_uid) do
    pull_fun = fn -> MeilisearchAPI.get_task(%{task_uid: task_uid}, meilisearch_opts()) end
    condition_fun = fn {:ok, task} -> task.status in [:succeeded, :failed, :canceled] end
    wait_fun = fn retry_count -> Process.sleep(retry_count * :timer.seconds(1)) end

    Puller.pull(pull_fun, condition_fun, wait_fun)
    |> tap(fn {:ok, %{task_uid: task_uid, type: type, status: status}} ->
      Logger.debug("Task ##{task_uid} #{type} is #{status}")
    end)
  end

  defp meilisearch_opts() do
    %{host: Meilisearch.host(), api_key: Meilisearch.api_key()}
  end
end
