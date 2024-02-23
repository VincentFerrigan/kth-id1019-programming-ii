defmodule Day05 do
  @moduledoc """
  Documentation for `Day05`.

  Provides solutions for the "Day 5" challenge, which involves navigating through transformations
  applied to seeds and ranges. It includes functionality to parse input data, apply transformations,
  and determine the lowest location number after applying a series of transformations as specified
  by the challenge. It supports both individual seed processing and range-based processing for efficiency.
  """

  @doc """
  Processes the input file for part 1 of the challenge, finding the lowest location number for individual seeds.

  ## Parameters
  - file_path: The path to the input file (default: "./input/sample").

  ## Returns
  - The lowest location number after applying transformations to the seeds.

  ## Examples
    iex> Day05.run_part_1("./input/sample")
    35 # The lowest location number after transformations of the test-sample given in AOC
  """
  @spec run_part_1(String.t()) :: integer
  def run_part_1(file_path \\ "./input/sample") do
    # Read the input from the given file path. Default path is "./input/sample".
    {:ok, input} = file_path |> File.read()
    # Split the input into seeds and maps sections, each separated by double newlines, and trim any whitespace.
    [seeds_str | maps_str] = String.split input, "\n\n", trim: true

    # Parse each transformation map from the maps section of the input.
    maps = Enum.map(maps_str, &parse_maps(&1))

    seeds_str
    |> parse_seeds # Parse the seeds from the input string
    |> Enum.map(&do_traverse(&1, maps)) # For each seed, apply the series of transformations defined in the maps,
    |> Enum.min # then find and return the minimum value among the resulting locations.
  end

  ## Parsing functions
  @doc """
  Parses a string of seeds into a list of integers.

  ## Parameters
  - seeds_str: A binary string starting with "seeds: " followed by the seeds.

  ## Returns
  - A list of seed integers.

  ## Examples

    iex> Day05.parse_seeds("seeds: 1 2 3 4 5")
    [1, 2, 3, 4, 5]
  """
  @spec parse_seeds(String.t()) :: [integer]
  def parse_seeds(<<"seeds: ", seeds_str::binary>>) do
    # A string in Elixir is a UTF-8 encoded binary.
    parse_line(seeds_str)
  end

  @doc """
  Parses transformation maps from a string input.

  ## Parameters
  - input: A string containing transformation data.

  ## Returns
  - A list of maps each representing a transformation.
  """
  @spec parse_maps(String.t()) :: [%{dest: integer, src: integer, len: integer}]
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

  @doc """
  Applies transformations to a range of seeds and determines the new range after transformations.

  ## Parameters
  - range: The range of seeds to be transformed.
  - maps: A list of transformation maps to apply.

  ## Returns
  - The transformed range as per the transformation maps.
  """
  @spec traverse(Range.t(), list) :: Range.t() | nil
  # wrapper that kicks off the traversing
  def traverse(range, []), do: range
  def traverse(range, [map|maps]), do: traverse(range, map, maps)

  @doc """
  Traverses through transformation maps for a given range, applying transformations sequentially.

  This overloaded version of `traverse` takes an additional parameter for the current map being processed
  and manages the recursive traversal through the maps for a given seed range. It applies transformations
  based on the current map and continues with the rest, allowing for complex transformations across multiple maps.

  ## Parameters
  - range: The range of seeds to apply transformations to.
  - maps: The list of maps that describe transformations.
  - current_map: The current transformation map being processed.

  ## Returns
  - The transformed range after applying all relevant transformations.
  """
  @spec traverse(Range.t(), [%{dest: integer(), src: integer(), len: integer()}], list) :: Range.t() | nil
  def traverse(range, [], maps), do: traverse(range, maps)
  def traverse(first..last = _range, [%{dest: dest, src: src, len: len} = _line | lines], maps) do
    if Range.disjoint?(first..last, src..(src + len)) do
      traverse(first..last, lines, maps)
      else
        [if (first < src-1) do traverse(first..src-1, lines, maps) end,
          traverse(get_new_range(max(first, src)..min(last, src + len - 1), dest, src, len), maps),
          if (src+len) < last do  traverse((src+len)..last, lines, maps) end]
      end
  end

  # Calculate the new range after applying a transformation.
  defp get_new_range(first..last, dest, src, _len) do
    (first - src + dest)..(last - src + dest)
  end

#   Traverse through all the maps
  defp do_traverse(num, []) when is_integer(num), do: num
  defp do_traverse(num, [map| maps]) when is_integer(num) do
    do_traverse(locate(num, map), maps)
  end

  # Locate next destination for base cases
  def locate(num, []), do: num

  # Overloaded locate for a list of map entries - this is where the iteration happens
  def locate(num, maps) when is_list(maps), do: do_locate(num, maps)
  # Locate for a single map entry
  def locate(num, %{dest: dest, src: src, len: len}) do
    if num >= src and num < (src + len), do: (num - src + dest), else: nil
  end

  # Helper function for iteration
  defp do_locate(num, []), do: num # No match found after going through all maps
  defp do_locate(num, [head | tail]) do
    case locate(num, head) do
      nil -> do_locate(num, tail) # No match, continue with the rest
      match -> match # Match found, return it immediately
    end
  end

  # part2
  @doc """
  Processes the input file for part 2 of the challenge, optimizing for ranges of seeds.

  ## Parameters
  - file_path: The path to the input file (default: "./input/sample").

  ## Returns
  - The lowest location number after applying transformations to the ranges of seeds.

  ## Examples
    iex> Day05.run_part_2("./input/sample")
    46 # The lowest location number after transformations of the test-sample given in AOC
  """
  @spec run_part_2(String.t()) :: integer
  def run_part_2(file_path \\ "./input/sample") do
    # Read the input from the given file path. Default path is "./input/sample".
    {:ok, input} = file_path |> File.read()
    # Split the input into seeds and maps sections, trimming any leading/trailing whitespace
    [seeds_str | maps_str] = String.split input, "\n\n", trim: true
    # Parse the transformation maps from the input
    maps = Enum.map(maps_str, &parse_maps(&1))

    seeds_str
    |> parse_seeds # Parse the seeds from the input string
    |> create_ranges() # Create ranges
    |> merge_overlapping # Merge any overlapping ranges to optimize
    |> Enum.map(&traverse(&1,maps)) # Apply transformations to each range
    |> List.flatten() # Flatten the list of transformed ranges into a single list
    |> Enum.filter(fn x -> x != nil end) # Filter out any nil values
    |> Enum.min() # Find the minimum range in the list
    |> Enum.min() # Get the minimum value in the range
  end

  # TODO Don't know if necessary, but this filters out all ranges that overalap.
  # TODO Should I use it here and/or elsewhere?
  @doc """
  Merges overlapping ranges into a single range for efficiency.

  ## Parameters
  - ranges: A list of ranges.

  ## Returns
  - A list of merged ranges, with no overlaps.
  """
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

  @doc """
  Merges two ranges into a single range.

  ## Parameters
  - first: The first range to merge.
  - second: The second range to merge.

  ## Returns
  - The resulting merged range.

  ## Examples

    iex> Day05.merge_ranges(1..5, 4..10)
    1..10
  """
  @spec merge_ranges(Range.t(), Range.t()) :: Range.t()
  def merge_ranges(first1..last1, _first2..last2) do
    first1..max(last1, last2)
#    min(first1, first2)..max(last1, last2)
  end

  @spec create_ranges([integer]) :: [Range.t()]
  def create_ranges(seeds) do
    seeds
    |> Enum.chunk_every(2) # Group every two elements (start and range) into a tuple
    |> Enum.map(fn [start, range] -> start..(start + range - 1) end) # Convert tuples into ranges
  end

end