defmodule EnvListTest do
  use ExUnit.Case

  alias EnvList

  @moduletag :capture_log

  doctest EnvList

  test "module exists" do
    assert is_list(EnvList.module_info())
  end
end
