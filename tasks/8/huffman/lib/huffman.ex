defmodule Huffman do
  @moduledoc """
  Provides functionality for Huffman encoding and decoding.

  This module allows for the construction of a Huffman tree based on the frequency
  of characters in a given text, generation of encoding and decoding tables, and
  supports encoding and decoding of text using the generated Huffman codes.
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

  @doc """
  Encodes the given text, generating a Huffman tree, encoding table, and then encoding the text.

  ## Parameters
  - text: The text to be encoded.

  ## Returns
  - A tuple {:ok, encoded_text, decoding_table} containing the encoded text and the decoding table for further decoding.

  ## Examples

  iex> Huffman.run_encoding("example text")
  {:ok, <<141, 116, 214, 120, 7::size(3)>>,
   %{
     <<0::size(2)>> => "x",
     <<2::size(3)>> => "p",
     <<6::size(4)>> => "l",
     <<7::size(4)>> => "m",
     <<2::size(2)>> => "e",
     <<12::size(4)>> => " ",
     <<13::size(4)>> => "a",
     <<7::size(3)>> => "t"
   }}
  """
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

  @doc """
  Reads text from a file and encodes it using Huffman encoding.

  ## Parameters
  - file_path: The path to the text file. Defaults to "./input/kallocain.txt".

  ## Returns
  - A tuple {:ok, original_text, encoded_text, decoding_table} containing the original text, encoded text, and the decoding table.
  """
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

  @doc """
  Decodes a given bitstring using the provided decoding table.

  ## Parameters
  - bits: The bitstring to decode.
  - decoding_table: The decoding table used for decoding.

  ## Returns
  - A tuple {:ok, decoded_text} with the decoded text.
  """
  def run_decoding(bits, decoded_table) do
    {:ok, decode_bits(bits, decoded_table)}
  end

  def build_tree(text) do
    text
    |> calculate_frequencies()
    |> build_priority_queue()
    |> construct_tree()
  end

  @doc """
  Calculates the frequency of each character in the given text.

  ## Parameters
  - text: The text from which to calculate character frequencies.

  ## Returns
  - A map with characters as keys and their frequencies as values.
  """
  @spec calculate_frequencies(String.t()) :: map()
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

  @doc """
  Builds a priority queue from the character frequency map.

  ## Parameters
  - freq_map: A map with characters as keys and their frequencies as values.

  ## Returns
  - A list of Huffman nodes sorted by frequency, forming a priority queue.
  """
  @spec build_priority_queue(map) :: priority_queue()
  def build_priority_queue(freq_map) do
    freq_map
    |> Enum.map(fn {char, frequency} -> %Huffman{char: char, frequency: frequency} end)
    |> Enum.sort_by(&(&1.frequency))
  end


  @doc """
  Constructs the Huffman tree from the priority queue.

  ## Parameters
  - queue: A priority queue of Huffman nodes.

  ## Returns
  - The root node of the constructed Huffman tree.
  """
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
  @doc """
  Generates the encoding table from a Huffman tree.

  ## Parameters
  - tree: The root node of the Huffman tree.

  ## Returns
  - An encoding table mapping characters to their encoded bitstrings.
  """
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
  @doc """
  Encodes a given text using the provided encoding table.

  ## Parameters
  - text: The text to encode.
  - encoding_table: A table mapping characters to their encoded bitstrings.

  ## Returns
  - The encoded text as a bitstring.
  """
  @spec encode_text(String.t(), encoding_table()) :: bitstring()
  def encode_text(text, encoding_table) do
    text
    |> String.graphemes()
    |> Enum.map(&Map.fetch!(encoding_table, &1))
    |> List.foldl(<<>>, fn bits, acc -> <<acc::bitstring, bits::bitstring>> end)
  end

  @doc """
  Decodes a given bitstring using the provided decoding table.

  ## Parameters
  - bits: The bitstring to decode.
  - decoding_table: A table mapping encoded bitstrings to their respective characters.

  ## Returns
  - The decoded text as a string.
  """
  @spec decode_bits(bitstring(), decoding_table()) :: String.t()
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




  # Benchmarking... redo
  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    length = bit_size(binary)
    {binary, length}
  end

  def bench() do
    {text, length} = read("./input/kallocain.txt")
    {tree, tree_time} = time_micro_s(fn -> build_tree(text) end)
    {encode_table, encode_table_time} = time_micro_s(fn -> generate_encoding_table(tree) end)
    # {decode_table, decode_table_time} = time_micro_s(fn -> generate_decoding_table(generate_encoding_table(tree)) end)
    {decode_table, decode_table_time} = time_micro_s(fn -> generate_decoding_table((encode_table)) end)
    {encode, encode_time} = time_micro_s(fn -> encode_text(text, encode_table) end)
    {_, decoded_time} = time_micro_s(fn -> decode_bits(encode, decode_table) end)

    # e = div(bit_size(encode), 8)
    # r = Float.round(e / length, 3)
    r = Float.round(bit_size(encode) / length, 3)

    IO.puts("Tree Build Time: #{tree_time} us")
    IO.puts("Encode Table Time: #{encode_table_time} us")
    IO.puts("Decode Table Time: #{decode_table_time} us")
    IO.puts("Encode Time: #{encode_time} us")
    IO.puts("Decode Time: #{decoded_time} us")

    IO.puts("Bitsize of text #{length}")
    IO.puts("Bitsize of compressed_text #{bit_size(encode)}")

    IO.puts("Bytesize of text #{div(length, 8)}")
    IO.puts("Bytesize of compressed_text #{div(bit_size(encode), 8)}")

    IO.puts("Compression Ratio: #{r}")
  end

  def time_micro_s(func) do
    {func.(), elem(:timer.tc(fn () -> func.() end), 0)}
  end



  # Montish bench
  # This is the benchmark of the single operations in the
  # Huffman encoding and decoding process.
  def bench(file, n) do
    {text, b} = read(file, n)
    c = byte_size(text)
    {tree, t2} = time_ms(fn -> build_tree(text) end)
    {encode, t3} = time_ms(fn -> generate_encoding_table(tree) end)
    s = map_size(encode)
    {decode, _} = time_ms(fn -> generate_decoding_table(encode) end)
    {encoded, t5} = time_ms(fn -> encode_text(text, encode) end)
    e = div(bit_size(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time_ms(fn -> decode_bits(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time_ms(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

 # Get a suitable chunk of text to encode.
  def read(file, n) do
   {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    {binary, length}
  end



  def banch(file, n) do
    {text, b} = read(file, n)
    c = byte_size(text)
    {tree, t2} = time_ms(fn -> build_tree(text) end)
    {encode, t3} = time_ms(fn -> generate_encoding_table(tree) end)
    s = map_size(encode)
    {decode, _} = time_ms(fn -> generate_decoding_table(encode) end)
    {encoded, t5} = time_ms(fn -> encode_text(text, encode) end)
    e = div(bit_size(encoded), 8)
    r = Float.round(e / b, 3)

    {_, t6} = time_ms(fn -> decode_bits(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

end
