defmodule EnvTreeTest do
  use ExUnit.Case

  alias EnvTree

  @moduletag :capture_log

  doctest EnvTree

  test "module exists" do
    assert is_list(EnvTree.module_info())
  end
end
