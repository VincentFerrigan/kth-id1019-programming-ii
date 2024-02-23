defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "Parsing seeds" do
    assert Day05.parse_seeds("seeds: 79 14 55 13") == [79,14,55,13]
  end

  test "merge overlapping ranges" do
    ranges = [5..15, 3..20, 30..40, 50..70, 35..45 ]
    assert Day05.merge_overlapping(ranges) |> Enum.sort == [3..20, 30..45, 50..70]
  end

  test "Run sample for Part 1" do
    assert Day05.part_1("./input/sample") == 35
  end

  test "Run input for Part 1" do
    assert Day05.part_1("./input/input") == 282277027
  end

  test "Run sample for Part 2" do
    assert Day05.part_2("./input/sample") == 46
  end

  @tag timeout: 600_000
  test "Run input for Part 2" do
    assert Day05.part_2("./input/input") == 11554135
  end
end