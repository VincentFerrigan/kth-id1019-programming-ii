defmodule Day05 do
  @moduledoc """
  Documentation for `Day05`.
  """
  def part_1(file_path \\ ".input/sample") do
    {:ok, input} = file_path |> File.read()
    run_sample(input)
#    try do
#      result = file_path
#               |> File.read()
#               |> run_sample()
#      {:ok, result} # Wrap the computation result in {:ok, _}
#    rescue
#      e in [File.Error] -> {:error, "Failed to process file: #{e.message}"}
#    end
  end

  #  @spec run_sample(String.t()) :: [integer]
  def run_sample(input) do
    [seeds_str | maps_str] = String.split input, "\n\n", trim: true
    seeds = parse_seeds seeds_str
    maps = Enum.map(maps_str, &parse_maps(&1))
    Enum.map(seeds, &traverse(&1, maps)) |> Enum.min
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

  # Traverse through all the maps
  def traverse(num, []), do: num
  def traverse(num, [map | maps]) do
    traverse(locate(num, map), maps)
  end

  # Locate next destination
  def locate(num, []), do: num
  def locate(_num, [x]), do: x

  def locate(num, %{dest: dest, src: src, len: len}) do
    if num >= src and num < (src + len), do: num- src + dest, else: nil
  end

  def locate(num, map) do
    locate(num, Enum.map(map, &locate(num, &1)) |> Enum.filter(&is_integer/1))
  end

end
