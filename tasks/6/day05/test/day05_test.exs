defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "Parsing seeds" do
    assert Day05.parse_seeds("seeds: 79 14 55 13") == [79,14,55,13]
  end

  test "Parse sample" do
    assert Day05.part_1("./input/sample") == 35
  end

  test "Part 1" do
    assert Day05.part_1("./input/part_1_input") == 282277027
  end
end
