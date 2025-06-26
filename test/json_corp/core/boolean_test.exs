defmodule JsonCorp.Core.BooleanTest do
  use ExUnit.Case, async: true
  alias JsonCorp.Core.Boolean

  describe "run/3" do
    test "with false" do
      assert Boolean.run(1, false, &(&1 + 1)) == 1
    end

    test "with true" do
      assert Boolean.run(1, true, &(&1 + 1)) == 2
    end
  end
end
