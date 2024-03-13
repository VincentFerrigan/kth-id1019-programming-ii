defmodule MorseTest do
  use ExUnit.Case
  doctest Morse

  describe "decode/2" do
    test "decodes a simple Morse code message" do
      signal = ".... . .-.. .-.. ---"
      tree = MyMorseCode.tree()
      assert Morse.decode(signal, tree) == "hello"
    end

    test "decodes a message with spaces correctly" do
      signal = ".... . .-.. .-.. --- ..-- .-- --- .-. .-.. -.."
      tree = MyMorseCode.tree()
      assert Morse.decode(signal, tree) == "hello world"
    end
  end

  describe "encode/1" do
    test "encodes space" do
      assert Morse.encode(" ") == "..--"
    end

    test "encodes a word with correct letter spacing" do
      assert Morse.encode("sos") == "... --- ..."
    end

    test "encodes a sentence with spaces between words" do
      assert Morse.encode("help me") == ".... . .-.. .--. ..-- -- ."
    end

    test "encodes individual letters" do
      assert Morse.encode("e") == "."
      assert Morse.encode("t") == "-"
    end

    test "encodes numbers" do
      assert Morse.encode("1") == ".----"
      assert Morse.encode("2") == "..---"
    end


    test "handles characters not in Morse code tree" do
      assert Morse.encode("~") == ""
    end

    test "handles empty input" do
      assert Morse.encode("") == ""
    end
  end
end
