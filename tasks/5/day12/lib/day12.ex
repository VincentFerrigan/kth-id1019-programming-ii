defmodule Day12 do
  @moduledoc """
  Implements the solution for the Advent of Code 2023, Day 12 puzzle.
  This module focuses on analyzing a field of hot springs, where each spring's condition
  can be operational, damaged, or unknown. The main challenge is to determine the total number
  of valid spring arrangements across all rows based on partial descriptions and sequences of damaged springs.
  """

  @doc """
  Calculates the total number of valid spring arrangements from a file containing rows of spring descriptions.

  Each line in the file represents a row of springs with their conditions (operational, damaged, or unknown)
  followed by a sequence of integers indicating the consecutive counts of damaged springs.

  ## Parameters
  - file_path: The path to the input file containing the spring descriptions.

  ## Returns
  {:ok, integer} when successful, {:error, string} if an error occurs during file processing.
  """
  @spec part_1(String.t()) :: {:ok, integer} | {:error, String.t()}
  def part_1(file_path) do
    try do
      result = file_path
               |> File.stream!()
               |> Enum.map(&String.trim/1)
               |> Stream.map(&parse_line/1)
               |> Enum.map(&brute_force_solve/1)
               |> Enum.sum()
      {:ok, result} # Wrap the computation result in {:ok, _}
    rescue
      e in [File.Error] -> {:error, "Failed to process file: #{e.message}"}
    end
  end

  @doc """
  Runs the sample input and calculates the total number of valid spring arrangements.

  This function takes an input string representing the sample spring descriptions,
  separates each line into spring conditions and damaged springs sequence,
  then calculates the total number of valid arrangements using a brute force approach.

  ## Parameters
  - input: A string containing the sample spring descriptions.

  ## Returns
  The total number of valid configurations that match the given sequences of damaged springs.

  ## Example
  iex> Day12.run_sample("???.### 1,1,3\\n.??..??...?##. 1,1,3")
  5
  """
  @spec run_sample(String.t()) :: integer
  def run_sample(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&brute_force_solve/1)
    |> Enum.sum()
  end

  @spec run_sample(String.t(), integer) :: integer
  def run_sample(input, multiplier) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&extend_input(&1, multiplier))
    |> Enum.map(&parse_line/1)
    |> Enum.map(&brute_force_solve/1)
    |> Enum.sum()
  end

  @doc """
  Parses a single line from the input, separating the spring condition pattern from the sequence of damaged springs.

  ## Parameters
  - line: A string representing a row of springs and their conditions.

  ## Returns
  A tuple where the first element is a list of characters representing the spring conditions,
  and the second element is a list of integers representing the sequence of damaged springs.
  ## Examples

    iex> Day12.parse_line("????.######..#####. 1,6,5")
    {~c"????.######..#####.", [1, 6, 5]}
  """
  @spec parse_line(String.t()) :: {[char], [integer]}
  def parse_line(line) do
    [pattern, sequence_str] = String.split(line, " ")
    sequence = String.split(sequence_str, ",")
               |> Enum.map(&String.to_integer/1)
    pattern = String.to_charlist(pattern)
    {pattern, sequence}
  end

  @doc """
  Solves for the number of valid arrangements of springs based on a given pattern and sequence of damaged springs.

  Uses a brute force approach to explore all possible configurations of unknown springs ('?') to match the provided sequence of damaged springs.

  ## Parameters
  - input: A tuple containing the pattern of springs as a charlist and the sequence of damaged springs as a list of integers.

  ## Returns
  The total number of valid configurations that match the given sequence of damaged springs.

  ## Examples

    iex> Day12.brute_force_solve({~c"????.######..#####.", [1, 6, 5]})
    4
  """
  @spec brute_force_solve({[char], [integer]}) :: [integer]
  def brute_force_solve({pattern, sequence}) do
    count(pattern, sequence, false, 0)
  end

  # Private helper functions for `brute_force_solve` are defined below.
  # These functions recursively explore different combinations of springs
  # and count the number of valid arrangements according to the sequence of damaged springs.
  # These functions handle operational, damaged, and unknown springs, respecting the constraints
  # given by the sequence of damaged springs.
  #
  # The `count` function is overloaded with several clauses to handle different cases in the pattern
  # and sequence, implementing the recursive exploration of configurations.
  defp count([], [], _needs_dot, 0), do: 1
  defp count([], [], _needs_dot, needs_hashes) when needs_hashes > 0, do: 0
  defp count([], [_ | _], _, _), do: 0
  defp count([?# | _], _sequence, true, _), do: 0
  defp count([?# | _], [], _, 0), do: 0
  defp count([?# | record], sequence, false, 1), do:
    count(record, sequence, true, 0)
  defp count([?# | record], sequence, false, need_hashes) when need_hashes > 1,
       do: count(record, sequence, false, need_hashes - 1)
  defp count([?# | record], [run | sequence], false, 0),
       do: count(record, sequence, run == 1, run - 1)
  defp count([?. | record], sequence, _needs_dot, 0),
       do: count(record, sequence, false, 0)
  defp count([?. | _], _sequence, _needs_dot, need_hashes) when need_hashes > 0,
       do: 0
  defp count([?? | record], sequence, true, 0),
       do: count(record, sequence, false, 0)
  defp count([?? | record], [], false, 0), do: count(record, [], false, 0)
  defp count([?? | record], sequence, false, 1),
       do: count(record, sequence, true, 0)
  defp count([?? | record], sequence, false, need_hashes) when need_hashes > 1,
       do: count(record, sequence, false, need_hashes - 1)
  defp count([?? | record], [s | sequence], false, 0) do
    put_dot = count(record, [s| sequence], false, 0)
    put_hash = count(record, sequence, (s == 1), s - 1)
    put_dot + put_hash
  end

  # Part II
  @spec part_2(String.t(), integer) :: {:ok, integer} | {:error, String.t()}
  def part_2(file_path, multiplier) do
    try do
      result = file_path
               |> File.stream!()
               |> Enum.map(&String.trim/1)
               |> Enum.map(&extend_input(&1, multiplier))
               |> Stream.map(&parse_line/1)
               |> Enum.map(&brute_force_solve/1)
               |> Enum.sum()
      {:ok, result} # Wrap the computation result in {:ok, _}
    rescue
      e in [File.Error] -> {:error, "Failed to process file: #{e.message}"}
    end
  end

  @doc """
  Extends the input string by repeating each pattern and damaged sequence according to the specified multiplier.

  ## Parameters
  - input: A string containing the original pattern and damaged sequences.
  - multiplier: An integer specifying how many times each pattern and sequence should be repeated.

  ## Returns
  An extended string with patterns and damaged sequences repeated according to the multiplier.

  ## Example
  iex> Day12.extend_input("???.### 1,1,3", 2)
  "???.###????.### 1,1,3,1,1,3"
  """
  @spec extend_input(String.t(), integer) :: String.t()
  def extend_input(input, multiplier) do
    [pattern, sequence_str] = String.split(input, " ")
    extended_pattern = Enum.join(List.duplicate(pattern, multiplier), "?")
    extended_sequence_str = Enum.join(List.duplicate(sequence_str, multiplier), ",")
    Enum.join([extended_pattern, extended_sequence_str], " ")
  end

  @doc """
  Runs the dynamic sample input and calculates the total number of valid spring arrangements.

  This function takes an input string representing the dynamic sample spring descriptions,
  extends each line's pattern and damaged springs sequence according to the provided multiplier,
  then calculates the total number of valid arrangements using a dynamic programming approach.

  ## Parameters
  - input: A string containing the dynamic sample spring descriptions.
  - multiplier: An integer specifying how many times each pattern and sequence should be repeated.

  ## Returns
  The total number of valid configurations that match the given sequences of damaged springs.

  ## Example
  iex> Day12.run_dynamic_sample("???.### 1,1,3\\n.??..??...?##. 1,1,3", 5)
  16385
  """
  @spec run_dynamic_sample(String.t(), integer) :: integer
  def run_dynamic_sample(input, multiplier) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&extend_input(&1, multiplier))
    |> Enum.map(&parse_line/1)
    |> Enum.map(&dynamic/1)
    |> Enum.sum()
  end

  @spec run_dynamic_sample(String.t()) :: integer
  def run_dynamic_sample(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&dynamic/1)
    |> Enum.sum()
  end

  @doc """
  Dynamic programming solution for calculating the number of valid arrangements of springs.

  This function takes a tuple containing the pattern of springs as a charlist and the sequence of damaged springs as a list of integers.
  It recursively calculates the total number of valid configurations using a dynamic programming approach.

  ## Parameters
  - input: A tuple containing the pattern of springs as a charlist and the sequence of damaged springs as a list of integers.

  ## Returns
  A tuple where the first element is the total number of valid configurations that match the given sequence of damaged springs,
  and the second element is the updated memoization table storing intermediate results.

  Note: This function is used internally for memoization in the dynamic programming approach.

  ## Examples

    iex> Day12.dynamic({~c"????.######..#####.", [1, 6, 5]})
    4
  """
  def dynamic({pattern, sequence}) do
    {result, _} = dynamic({pattern, sequence, false, 0}, %{})
    result
  end

  def dynamic(args = {pattern, sequence, needs_dot, need_hashes}, mem) do
    case Map.get(mem, args) do
      nil ->
        {result, new_mem} = count(pattern, sequence, needs_dot, need_hashes, mem)
        {result, Map.put(new_mem, args, result)}
      result ->
        {result, mem}
    end
  end

  defp count([], [], _needs_dot, 0, mem),
       do: {1, mem}
  defp count([], [], _needs_dot, needs_hashes, mem) when needs_hashes > 0,
       do: {0, mem}
  defp count([], [_ | _], _, _, mem),
       do: {0, mem}
  defp count([?# | _], _sequence, true, _, mem),
       do: {0, mem}
  defp count([?# | _], [], _, 0, mem),
       do: {0, mem}

  defp count([?# | record], sequence, false, 1, mem),
       do: count(record, sequence, true, 0, mem)
  defp count([?# | record], sequence, false, need_hashes, mem) when need_hashes > 1,
       do: count(record, sequence, false, need_hashes - 1, mem)
  defp count([?# | record], [run | sequence], false, 0, mem),
       do: count(record, sequence, run == 1, run - 1, mem)
  defp count([?. | record], sequence, _needs_dot, 0, mem),
       do: count(record, sequence, false, 0, mem)
  defp count([?. | _], _sequence, _needs_dot, need_hashes, mem) when need_hashes > 0,
       do: {0, mem}
  defp count([?? | record], sequence, true, 0, mem),
       do: count(record, sequence, false, 0, mem)
  defp count([?? | record], [], false, 0, mem),
       do: count(record, [], false, 0, mem)
  defp count([?? | record], sequence, false, 1, mem),
       do: count(record, sequence, true, 0, mem)
  defp count([?? | record], sequence, false, need_hashes, mem) when need_hashes > 1,
       do: count(record, sequence, false, need_hashes - 1, mem)
  defp count([?? | record], [s | sequence], false, 0, mem) do
    {put_dot, _} = dynamic({record, [s| sequence], false, 0}, mem)
    {put_hash,_} = dynamic({record, sequence, (s == 1), s - 1}, mem)
    {put_dot + put_hash, mem}
  end

end