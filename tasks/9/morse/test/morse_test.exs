defmodule MorseTest do
  use ExUnit.Case
  doctest Morse

  describe "decode/2" do
    test "decodes a simple Morse code message" do
      signal = ".- .-.. .-.."
      tree = Code.tree() # Assuming you have a function to construct the tree
      assert Morse.decode(signal, tree) == "ALL"
    end

    test "decodes a message with spaces correctly" do
      signal = ".- .-.. .-..  ..-- -.-- --- ..-"
      tree = Code.tree()
      assert Morse.decode(signal, tree) == "ALL YOUR"
    end
  end

end
