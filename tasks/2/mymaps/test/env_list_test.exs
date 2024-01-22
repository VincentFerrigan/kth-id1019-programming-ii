defmodule EnvListTest do
  use ExUnit.Case
  doctest EnvList

  test "New list" do
    assert EnvList.new() == []
  end

  test "add to empty list"  do
    list = []
    key = :a
    value = 1
    assert EnvList.add(list, key, value) == [{key, value} | list]
  end

  test "add to list"  do
    list = [a: 0, b: 1, c: 2, d: 3, e: 4]
    key = :f
    value = 5
    assert EnvList.add(list, key, value) == [a: 0, b: 1, c: 2, d: 3, e: 4, f: 5]
  end

  test "replace value in list"  do
    list = [a: 1, b: 1, c: 2, d: 3]
    key = :a
    value = 0
    tail = tl list
    assert EnvList.add(list, key, value) == [{key, value} | tail]
  end

  test "key in list" do
    l = [a: 1, b: 2, c: 3]
    v = EnvList.lookup(l, :b)
    assert v == {:b, 2}
  end

  test "key not in list" do
    l = [a: 1, b: 2, c: 3]
    v = EnvList.lookup(l, :d)
#    assert v == []
    assert v == nil
  end

end