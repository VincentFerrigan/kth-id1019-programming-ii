defmodule HuffmanTest do
  use ExUnit.Case
  doctest Huffman

  describe "calculate_frequencies" do
    test "Return empty map for an empty string", do:
      assert Huffman.calculate_frequencies("") == %{}

    test "Determine frequency of each character" do
      text     = "aaabbc"
      exp_freq = %{"a" => 3, "b" => 2, "c" => 1}
      assert Huffman.calculate_frequencies(text) == exp_freq
    end
  end

  describe "build_priority_queue/1" do
    test "returns an empty list for empty frequencies map", do:
      assert Huffman.build_priority_queue(%{}) == []

    test "builds a priority queue from character frequencies" do
      frequencies = %{"a" => 3, "b" => 2, "c" => 1}
      expected_queue = [{1, "c"}, {2, "b"}, {3, "a"}] # Assuming a min-heap based on frequencies
      assert Huffman.build_priority_queue(frequencies) == expected_queue
    end
  end

  describe "construct_tree/1" do
  test "returns an empty tuple for an empty queue", do:
    assert Huffman.construct_tree([]) == {}

  test "Return a single node tree for a queue with one element" do
    queue = [{1, "a"}]
    expected_tree = {1, "a"}
    assert Huffman.construct_tree(queue) == expected_tree
  end

  test "Construct Huffman tree from a priority queue" do
    # Assuming the tree is a tuple with {left, right, frequency},
    # where left/right are characters or other tuples.
    queue = [{1, "c"}, {2, "b"}, {3, "a"}] # This queue is based on the example above
    expected_tree =
            {6,
      {3, "a"}, {3,
          {2, "b"}, {1, "c"}}}
    assert Huffman.construct_tree(queue) == expected_tree
  end
end


end
