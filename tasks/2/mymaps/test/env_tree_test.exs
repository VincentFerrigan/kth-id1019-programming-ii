defmodule EnvTreeTest do
  use ExUnit.Case

  doctest EnvTree

  test "New tree" do
    assert EnvTree.new() == :nil
  end

  test "add to empty tree" do
    key = :a
    value = 0
    assert EnvTree.add(EnvTree.new(), key, value)
      == {:node, :a, 0, :nil, :nil}
  end

  test "replace value in tree" do
  end
  test "look up value in tree" do
  end
  test "look up non existing key in tree" do
  end

  test "remove node from tree" do
  end
  describe "add/3" do
    test "adds a new key-value pair to an empty tree" do
      tree = EnvTree.new()
      assert EnvTree.add(tree, :a, 1) == {:node, :a, 1, :nil, :nil}
    end

    test "updates value for an existing key" do
      tree = {:node, :a, 1, :nil, :nil}
      assert EnvTree.add(tree, :a, 2) == {:node, :a, 2, :nil, :nil}
    end

    test "adds a new key-value pair to a non-empty tree" do
      tree = {:node, :a, 1, :nil, :nil}
      assert EnvTree.add(tree, :b, 2) == {:node, :a, 1, :nil, {:node, :b, 2, :nil, :nil}}
    end
  end

  describe "lookup/2" do
    test "returns nil for a key not in the tree" do
      tree = {:node, :a, 1, :nil, :nil}
      assert EnvTree.lookup(tree, :b) == nil
    end

    test "finds the value for a key in the tree" do
      tree = {:node, :a, 1, :nil, :nil}
      assert EnvTree.lookup(tree, :a) == {:a, 1}
    end
  end

  describe "remove/2" do
    test "removes a key-value pair and returns updated tree" do
      tree = {:node, :a, 1, :nil, :nil}
      assert EnvTree.remove(tree, :a) == :nil
    end

    test "returns the same tree if key is not found" do
      tree = {:node, :a, 1, :nil, :nil}
      assert EnvTree.remove(tree, :b) == tree
    end
  end
end
