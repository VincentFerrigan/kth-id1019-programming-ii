defmodule Day12Test do
  use ExUnit.Case
  doctest Day12


  describe "Part 1" do
    test "Test samples", do:
      assert Day12.run_sample("???.### 1,1,3") == 1
      assert Day12.run_sample(".??..??...?##. 1,1,3") == 4
      assert Day12.run_sample("?#?#?#?#?#?#?#? 1,3,1,6") == 1
      assert Day12.run_sample("????.#...#... 4,1,1") == 1
      assert Day12.run_sample("????.######..#####. 1,6,5") == 4
      assert Day12.run_sample("?###???????? 3,2,1") == 10
  end

end
