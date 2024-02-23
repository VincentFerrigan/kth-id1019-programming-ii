defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "Parsing seeds" do
    assert Day05.parse_seeds("seeds: 79 14 55 13") == [79,14,55,13]
  end

  test "Run sample for Part 1" do
    assert Day05.part_1("./input/sample") == 35
  end

  test "Run imput for Part 1" do
    assert Day05.part_1("./input/input") == 282277027
  end

  test "Run sample for Part 2" do
    assert Day05.part_2("./input/sample") == 46
  end
end