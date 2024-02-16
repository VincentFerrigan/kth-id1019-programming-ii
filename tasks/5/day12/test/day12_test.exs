defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  describe "Part 1" do
    test "Test brute force samples", do:
      assert Day12.run_sample("???.### 1,1,3") == 1
      assert Day12.run_sample(".??..??...?##. 1,1,3") == 4
      assert Day12.run_sample("?#?#?#?#?#?#?#? 1,3,1,6") == 1
      assert Day12.run_sample("????.#...#... 4,1,1") == 1
      assert Day12.run_sample("????.######..#####. 1,6,5") == 4
      assert Day12.run_sample("?###???????? 3,2,1") == 10
  end

  describe "Part 2" do
    test "Test dynamic programming samples, extended multiplier = 5", do:
      assert Day12.run_dynamic_sample("???.### 1,1,3", 5) == 1
      assert Day12.run_dynamic_sample(".??..??...?##. 1,1,3", 5) == 16384
      assert Day12.run_dynamic_sample("?#?#?#?#?#?#?#? 1,3,1,6", 5) == 1
      assert Day12.run_dynamic_sample("????.#...#... 4,1,1", 5) == 16
      assert Day12.run_dynamic_sample("????.######..#####. 1,6,5", 5) == 2500
      assert Day12.run_dynamic_sample("?###???????? 3,2,1", 5) == 506250
  end
end