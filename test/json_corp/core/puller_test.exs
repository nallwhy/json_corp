defmodule JsonCorp.Core.PullerTest do
  use ExUnit.Case, async: true
  alias JsonCorp.Core.Puller

  describe "pull/3" do
    setup do
      {:ok, agent} = Agent.start_link(fn -> 1 end)

      %{agent: agent}
    end

    test "test", %{agent: agent} do
      pid = self()

      pull_fun = fn -> Agent.get_and_update(agent, fn value -> {value, value + 1} end) end
      condition_fun = fn value -> value == 3 end
      wait_fun = fn retry_count -> send(pid, {:wait, retry_count}) end

      assert Puller.pull(pull_fun, condition_fun, wait_fun) == 3
      assert_received {:wait, 1}
      assert_received {:wait, 2}
      refute_received {:wait, 3}
    end
  end
end
