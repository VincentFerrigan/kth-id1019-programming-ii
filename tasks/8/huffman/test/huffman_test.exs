defmodule HuffmanTest do
  use ExUnit.Case
  doctest Huffman

  describe "Encode and decode" do
    test "back and forth from file" do
      {:ok, text, code, decoding_table}  = Huffman.run_encoding_from_file()
      {:ok, decoded_text} = Huffman.run_decoding(code, decoding_table)

      assert decoded_text == text
    end

    test "back and forth from text" do
      text = "Kommer det här att funka tro?"
      {:ok, code, decoding_table}  = Huffman.run_encoding(text)
      {:ok, decoded_text} = Huffman.run_decoding(code, decoding_table)

      assert decoded_text == text
    end

  end
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
      frequencies = %{"a" => 5, "b" => 3, "c" => 1}
      expected_queue = [
        %Huffman{char: "c", frequency: 1},
        %Huffman{char: "b", frequency: 3},
        %Huffman{char: "a", frequency: 5},]
      assert Huffman.build_priority_queue(frequencies) == expected_queue
    end
  end

  describe "construct_tree/1" do
    test "returns an empty node for an empty queue", do:
      assert Huffman.construct_tree([]) == %Huffman{}
      assert Huffman.construct_tree([%Huffman{}]) == %Huffman{}

    test "Return a single node tree for a queue with one element" do
      queue = [%Huffman{frequency: 1, char: "a"}]
      expected_tree = %Huffman{char: "a", frequency: 1, left: nil, right: nil}
      assert Huffman.construct_tree(queue) == expected_tree
    end

    # TODO lägg in Montes tester... se hur dom funkar


    test "Construct Huffman tree from a priority queue" do
      # Assuming the tree is a tuple with {left, right, frequency},
      # where left/right are characters or other tuples.
      queue = [
        %Huffman{frequency: 1, char: "c"},
        %Huffman{frequency: 2, char: "b"},
        %Huffman{frequency: 4, char: "a"}
      ]
      expected_tree =
      %Huffman{char: nil, frequency: 7,
        left: %Huffman{char: nil, frequency: 3,
            left: %Huffman{char: "c", frequency: 1},
            right: %Huffman{char: "b", frequency: 2}
            },
        right: %Huffman{char: "a", frequency: 4}
      }

      assert Huffman.construct_tree(queue) == expected_tree
    end
  end
end
