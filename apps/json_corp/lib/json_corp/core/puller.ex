defmodule JsonCorp.Core.Puller do
  def pull(pull_fun, condition_fun, wait_fun)
      when is_function(pull_fun, 0) and is_function(condition_fun, 1) and is_function(wait_fun, 1) do
    Stream.cycle([{:pull, pull_fun}, {:wait, wait_fun}])
    |> Stream.transform(1, fn
      {:pull, pull_fun}, retry_count ->
        {[pull_fun.()], retry_count}

      {:wait, wait_fun}, retry_count ->
        wait_fun.(retry_count)
        {[], retry_count + 1}
    end)
    |> Stream.drop_while(fn result ->
      not condition_fun.(result)
    end)
    |> Enum.take(1)
    |> List.first()
  end
end
