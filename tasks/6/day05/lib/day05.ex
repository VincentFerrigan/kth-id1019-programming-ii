defmodule Day05 do
  @moduledoc """
  Documentation for `Day05`.
  """
  def part_1(file_path \\ "./input/sample") do
    {:ok, input} = file_path |> File.read()
    run_sample(input)
  end

  #  @spec run_sample(String.t()) :: [integer]
  def run_sample(input) do
    [seeds_str | maps_str] = String.split input, "\n\n", trim: true
    seeds = parse_seeds seeds_str
    maps = Enum.map(maps_str, &parse_maps(&1))
    Enum.map(seeds, &do_traverse(&1, maps)) |> Enum.min
  end

  ## Parsing functions
  # A string is a UTF-8 encoded binary.
  @spec parse_seeds(String.t()) :: [integer]
  def parse_seeds(<<"seeds: ", seeds_str::binary>>) do
    parse_line(seeds_str)
  end

#  @spec parse_map([String.t()]) :: [integer]
  def parse_maps(input) do
    [_type | data] = String.split(input, "\n", trim: true)
    data
    |> Enum.map(&parse_line(&1))
    |> Enum.map(fn [dest, src, len] ->
      %{dest: dest, src: src, len: len} end)
  end

  def parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # wrapper that kicks off the traversing
  def traverse(range, []), do: range
  def traverse(range, [map|maps]), do: traverse(range, map, maps)

  def traverse(x..x, _, _), do: nil # TODO osäker på denna
  def traverse(range, [], maps), do: traverse(range, maps)
  def traverse(first..last = range, [%{dest: dest, src: src, len: len} = line | lines], maps) do
    if Range.disjoint?(first..last, src..(src + len)) do
#      IO.puts("disjoint #{first}..#{last}, #{src}..#{src+len}")
      traverse(first..last, lines, maps)
      else
#        if # TODO maps == [] then do_traverse or loacte
        if maps == [] do
#          IO.puts("Last one")
#          IO.inspect(range)
#          IO.inspect(line)
          Enum.map(range, &do_traverse(&1, [ [line | lines] | maps]))
        end
#        IO.puts("concat #{first}..#{last}, #{src}..#{src+len}")
        [traverse(min(first, src-1)..src-1, lines, maps),
          traverse(get_new_range(max(first, src)..min(last, src + len - 1), dest, src, len), maps),
#          Enum.map(max(first, src)..min(last, src + len - 1), &do_traverse(&1, [line | [map|maps]])) |> Enum.min,
          traverse(min(last,src+len)..last, lines, maps)]
#        |> List.flatten()
#        |> Enum.filter(&is_number(&1))
#        |> Enum.filter(&is_number(&1))
#        |> Enum.min
      end
  end

  def get_new_range(first..last, dest, src, _len) do
#    IO.inspect(first..last) # Debugging
#    IO.inspect((first - src + dest)..(last - src + dest)) # Debugging
    (first - src + dest)..(last - src + dest)
  end

#   Traverse through all the maps
  def do_traverse(num, []) when is_integer(num) do
#    IO.puts("last num: #{num}\n")
    num
  end

  def do_traverse(num, [map| maps]) when is_integer(num) do
    do_traverse(locate(num, map), maps)
  end

  # Locate next destination for base cases
  def locate(num, []), do: num
#  def locate(_num, [x]), do: IO.inspect(x)

  # Locate for a single map entry
  def locate(num, %{dest: dest, src: src, len: len}) do
#    IO.puts("do trav in map #{num}")
#    IO.puts("do trav #{src}..#{src+len}")
    if num >= src and num < (src + len), do: (num - src + dest), else: nil
  end

  # Overloaded locate for a list of map entries - this is where the iteration happens
  def locate(num, maps) when is_list(maps) do
#    IO.puts("do trav is list #{num}")
    do_locate(num, maps)
  end

  # Helper function for iteration
  defp do_locate(num, []), do: num # No match found after going through all maps
  defp do_locate(num, [head | tail]) do
    case locate(num, head) do
      nil -> do_locate(num, tail) # No match, continue with the rest
      match -> match # Match found, return it immediately
    end
  end

#  def locate(num, map) do
#    locate(num, Enum.map(map, &locate(num, &1)) |> Enum.filter(&is_integer/1))
#  end

  # part2
  def part_2(file_path \\ "./input/sample") do
    {:ok, input} = file_path |> File.read()
    run_sample_2(input)
  end

  def run_sample_2(input) do
    [seeds_str | maps_str] = String.split input, "\n\n", trim: true
    maps = Enum.map(maps_str, &parse_maps(&1))

    #TODO latest try
    ranges = seeds_str
             |> parse_seeds
             |> Enum.chunk_every(2)
             |> Enum.map(fn [start, range] -> start..(start + range - 1) end)
             |> merge_overlapping

    ##TODO latest try
      ranges
#      |> Enum.map(&traverse(&1,maps))

      |> Enum.map(fn x ->
        Task.async(fn ->
          traverse(x, maps) end)
      end)
      |> Enum.map(&Task.await(&1, 20_000)) # Await each traverse task

# TODO, filterera bort tomma [], ta ut min.
#      |> Enum.concat()
#      |> Enum.filter(fn x -> is_integer(hd(x)) end)
#      |> IO.inspect()
      |> List.flatten()
      |> Enum.filter(fn x -> x != nil end)
      |> Enum.min()
      |> Enum.min()

#      |> Enum.min() # Find the minimum of the results
#      |> hd
  end

  def merge_overlapping(ranges) do
    ranges
    |> Enum.sort # Sort ranges by their start value
    |> Enum.reduce([], &accumulate_ranges/2) # Accumulate, merging overlapping ranges
  end

  defp accumulate_ranges(current, []) do
    [current] # Initial case, the accumulator is empty
  end

  defp accumulate_ranges(current, [last_merged | rest] = acc) do
    # Check if the current range overlaps with the last merged range
    if Range.disjoint?(last_merged, current) do
      [current | acc]
    else
      # If they overlap, merge them and put it back into the accumulator
      merged = merge_ranges(last_merged, current)
      [merged | rest]
    end
  end

#  # Checks if two ranges overlap
#  defp range_overlap?(range1, range2) do
#    Enum.max(range1) >= Enum.min(range2) and Enum.min(range1) <= Enum.max(range2)
#  end

  # Merges two ranges
  def merge_ranges(first1..last1, _first2..last2) do
    first1..max(last1, last2)
#    min(first1, first2)..max(last1, last2)
  end

end