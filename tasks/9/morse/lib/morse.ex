defmodule Morse do
  @moduledoc """
  Documentation for `Morse`.
  """

  # Function to decode a given Morse code signal
  def decode(signal, tree) do
    # Split the signal into Morse code characters and decode each one
    signal
    |> String.split(" ")
    |> Enum.map(&decode_character(&1, tree))
    |> Enum.join()
  end

  # Helper function to decode a single Morse code character
  defp decode_character(morse_char, tree) do
    # Split the Morse code character into individual signals (dots and dashes)
    signals = String.graphemes(morse_char)

    # Traverse the tree based on the signals to find the corresponding character
    decode_signals(signals, tree)
  end

  # Recursive function to traverse the tree based on the signals
  defp decode_signals([], {:node, char, _, _}), do: char_to_string(char)
  defp decode_signals([signal | rest], {:node, _, long, short}) do
    case signal do
      "-" -> decode_signals(rest, long)
      "." -> decode_signals(rest, short)
      _ -> ""  # Return empty string for unrecognized signals
    end
  end
  defp decode_signals(_, :nil), do: ""

  # Convert character codes to string, handling :na and numbers
  defp char_to_string(:na), do: ""
  defp char_to_string(char) when is_integer(char), do: <<char>>


  ######## ENCODER ##############
  @encoding_table MyMorseCode.generate_encoding_table()

  # Function to encode a given text message into Morse code
  def encode(message) do
    message
    |> String.downcase()  # Normalize the message to uppercase
    |> String.graphemes()  # Break the message into a list of characters
    |> Enum.map(&encode_character/1)  # Encode each character
    |> Enum.join(" ")  # Join encoded characters with spaces
  end

  # Helper function to encode a single character using the encoding table
  defp encode_character(char) do
    # Convert the character to its ASCII value if needed, or keep the char as is if it's a control character like space
    ascii = if char == " ", do: 32, else: char |> String.to_charlist() |> hd()

    # Look up the character's Morse code in the encoding table
    Map.get(@encoding_table, ascii, "")
  end

end
