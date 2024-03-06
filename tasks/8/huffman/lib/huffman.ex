defmodule Huffman do
  @moduledoc """
  Documentation for `Huffman`.
  """

  # @spec calculate_frequencies(String.t()):: map()
  def calculate_frequencies(text) when is_binary(text) do
    text
    |> String.graphemes() # Handles UTF-8 multi-byte characters correctly
    |> Enum.reduce(%{}, fn grapheme, acc ->
      Map.update(acc, grapheme, 1, &(&1 + 1)) end)
  end

  # @spec calculate_frequencies(String.t()):: map()
  def calculate_frequencies_from_file(file_path) do
    file_path
    |> File.stream!()
    |> Stream.flat_map(&String.graphemes/1)
    |> Enum.reduce(%{}, fn grapheme, acc ->
      Map.update(acc, grapheme, 1, &(&1 + 1))end)
  end

  def build_priority_queue(%{}), do: []
  def build_priority_queue(map), do: [] #todo

  def construct_tree([]), do: {}
  def construct_tree(queue), do: [] #todo

end
