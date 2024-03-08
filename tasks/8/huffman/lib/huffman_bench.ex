defmodule HuffmanBench do
  # alias YourApp.Huffman

  def run do
    # Assuming you have a sufficiently long source text or generate it dynamically.
    source_text = File.read!("./input/kallocain.txt")
    # sample_lengths = [100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200, 102400, 204800]

    inputs = %{
    "100 characters"   => String.slice(source_text, 0, 100),
    "200 characters"   => String.slice(source_text, 0, 200),
    "400 characters"   => String.slice(source_text, 0, 400),
    "800 characters"   => String.slice(source_text, 0, 800),
    "1600 characters"  => String.slice(source_text, 0, 1600),
    "3200 characters"  => String.slice(source_text, 0, 3200),
    "6400 characters"  => String.slice(source_text, 0, 6400),
    "12800 characters" => String.slice(source_text, 0, 12800),
    "25600 characters" => String.slice(source_text, 0, 25600)
  }
  Benchee.run(
    %{
      "encode text" => fn input -> Huffman.run_encoding(input) end#,
      # "decode text" => {
      #   fn {:ok, encoded_text, dt} -> Huffman.decode_bits(encoded_text, dt) end,
      #   before_scenario: fn input -> Huffman.run_encoding(input) end
      # }
    },
     inputs: inputs,
     time: 10,
     formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
  )

  Benchee.run(
    %{
      "decode text" => fn {:ok, encoded_text, dt} -> Huffman.decode_bits(encoded_text, dt) end
    },
     inputs: inputs,
     time: 10,
     formatters: [{Benchee.Formatters.Console, extended_statistics: true}],
     before_each: fn input -> Huffman.run_encoding(input) end
  )


    # Enum.each(sample_lengths, fn length ->
    #   # Prepare the text sample
    #   sample_text = String.slice(source_text, 0, length)

    #   IO.puts("Benchmarking for text length: #{length}")

    #   tree = Huffman.build_tree(sample_text)
    #   encoding_table = Huffman.generate_encoding_table(tree)
    #   encoded_text = Huffman.encode_text(sample_text, encoding_table)
    #   s = byte_size(sample_text)
    #   e = div(bit_size(encoded_text), 8)
    #   r = Float.round(e/s, 3)
    #   IO.puts("Source #{s} bytes, encoded #{e} bytes, compression #{r}")


    #   # Benchmark
    #   Benchee.run(%{
    #     "build tree#{length}" => fn ->
    #       Huffman.build_tree(sample_text)
    #     end,
    #     "generate encoding table#{length}" => fn ->
    #       Huffman.generate_encoding_table(tree)
    #     end,
    #     "encode text with table #{length}" => fn ->
    #       Huffman.encode_text(sample_text, encoding_table)
    #     end,
    #     "encode text from sratch #{length}" => fn ->
    #       Huffman.run_encoding(sample_text)
    #     end,
    #     "decode text #{length}" => fn ->
    #       # tree = Huffman.build_tree(sample_text)
    #       # encoding_table = Huffman.generate_encoding_table(tree)
    #       decoding_table = Huffman.generate_decoding_table(encoding_table)
    #       # encoded_text = Huffman.encode_text(sample_text, encoding_table)
    #       Huffman.decode_bits(encoded_text, decoding_table)
    #     end
    #   },
    #   time: 3, # adjust based on your needs
    #   memory_time: 2 # adjust based on your needs
    #   )
    # end)
  end
end
