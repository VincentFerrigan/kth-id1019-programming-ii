defmodule Huffman do
  @moduledoc """
  Documentation for `Huffman`.
  """

  # Note: The struct is directly associated with the Huffman module (i.e., %Huffman{}).
  defstruct char: nil, frequency: 0, left: nil, right: nil

  @typedoc "Represents a Huffman node."
  @type huffman_node :: %__MODULE__{
          char: String.t() | nil,
          frequency: integer(),
          left: huffman_node() | nil,
          right: huffman_node() | nil
        }

  @typedoc "A Huffman tree, potentially empty."
  @type tree :: huffman_node() | nil

  @typedoc "A priority queue used to build the Huffman tree."
  @type priority_queue :: [huffman_node()]

  @typedoc "Encoding table mapping characters to bit strings."
  @type encoding_table :: %{required(String.t()) => bitstring()}

  @typedoc "Decoding table mapping bit strings to characters."
  @type decoding_table :: %{required(bitstring()) => String.t()}

  def run_encoding(text) do
    tree = text
    |> calculate_frequencies()
    |> build_priority_queue()
    |> construct_tree()

    encoding_table = tree |> generate_encoding_table()
    decoding_table = encoding_table |> generate_decoding_table()

    encoded_text  = encode_text(text, encoding_table)

    {:ok, encoded_text, decoding_table}
  end

  def run_encoding_from_file(file_path \\ "./input/kallocain.txt") do
    {:ok, text} = File.read(file_path)

    tree = text
    |> calculate_frequencies()
    |> build_priority_queue()
    |> construct_tree()

    encoding_table = tree |> generate_encoding_table()
    decoding_table = encoding_table |> generate_decoding_table()

    encoded_text  = encode_text(text, encoding_table)

    {:ok, text, encoded_text, decoding_table}
  end

  def run_decoding(bits, decoded_table) do
    {:ok, decode_bits(bits, decoded_table)}
  end

  def build_tree(text) do
    text
    |> calculate_frequencies()
    |> build_priority_queue()
    |> construct_tree()
  end

  def calculate_frequencies(text) when is_binary(text) do
    text
    |> String.graphemes() # Handles UTF-8 multi-byte characters correctly
    |> Enum.reduce(%{}, fn grapheme, acc ->
      Map.update(acc, grapheme, 1, &(&1 + 1)) end)
  end

  def calculate_frequencies_from_file(file_path) do
    file_path
    |> File.stream!()
    |> Stream.flat_map(&String.graphemes/1)
    |> Enum.reduce(%{}, fn grapheme, acc ->
      Map.update(acc, grapheme, 1, &(&1 + 1))end)
  end

  @spec build_priority_queue(map) :: priority_queue()
  def build_priority_queue(freq_map) do
    freq_map
    |> Enum.map(fn {char, frequency} -> %Huffman{char: char, frequency: frequency} end)
    |> Enum.sort_by(&(&1.frequency))
  end

  @spec construct_tree(priority_queue()) :: tree()
  def construct_tree([]), do: %Huffman{}
  def construct_tree([final_node]) when is_map(final_node), do: final_node
  def construct_tree(queue) do
    # Extract the two nodes with the lowest frequencies
    [node1, node2 | remaining_queue] = queue

    # Create a new combined node
    combined_node = %Huffman{
      frequency: node1.frequency + node2.frequency,
      left: node1,
      right: node2
    }

    # Insert the new node back into the priority queue
    new_queue = insert_in_order(combined_node, remaining_queue)
    # Recursively call construct_tree until one node remains
    construct_tree(new_queue)
  end

  defp insert_in_order(node, queue) do
    # Inserts node into the queue while maintaining sorted order by frequency
    Enum.sort([node | queue], &(&1.frequency <= &2.frequency))
  end


  # Step 2
  @spec generate_encoding_table(node()) :: encoding_table()
  def generate_encoding_table(tree) do
    traverse_tree(%{}, tree, <<>>)
  end

  defp traverse_tree(acc, nil, _), do: acc
  defp traverse_tree(acc, %Huffman{char: char, left: nil, right: nil} = _node, path) when not is_nil(char) do
    Map.put(acc, char, path)
  end

  defp traverse_tree(acc, %Huffman{left: left, right: right}, path) do
    acc
    |> traverse_tree(left, <<path::bitstring, 0::1>>)
    |> traverse_tree(right, <<path::bitstring, 1::1>>)
  end


  # Step 3
  @spec generate_decoding_table(encoding_table()) :: decoding_table()
  def generate_decoding_table(encoding_table) do
    Map.new(encoding_table, fn {k, v} -> {v, k} end)
  end

  # step 4
  @spec encode_text(String.t(), encoding_table()) :: bitstring()
  def encode_text(text, encoding_table) do
    text
    |> String.graphemes()
    |> Enum.map(&Map.fetch!(encoding_table, &1))
    |> List.foldl(<<>>, fn bits, acc -> <<acc::bitstring, bits::bitstring>> end)
  end

  @spec decode_bits(bitstring(), %{bitstring() => String.t()}) :: String.t()
  def decode_bits(bits, decoding_table) do
    decode_bits(bits, decoding_table, <<>>, "")
  end

  defp decode_bits(<<>>, _decoding_table, _current_bits, decoded_text), do: decoded_text

  defp decode_bits(<<bit::1, rest::bitstring>>, decoding_table, current_bits, decoded_text) do
    updated_bits = <<current_bits::bitstring, bit::1>>

    case Map.get(decoding_table, updated_bits) do
      nil ->
        decode_bits(rest, decoding_table, updated_bits, decoded_text)

      char ->
        decode_bits(rest, decoding_table, <<>>, decoded_text <> char)
    end
  end
end
