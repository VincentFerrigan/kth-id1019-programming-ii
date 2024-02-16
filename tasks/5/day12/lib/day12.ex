defmodule Day12 do
  @moduledoc """
  """

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

  def run_sample(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&brute_force_solve/1)
    |> Enum.sum()
  end

  def parse_line(line) do
    [pattern, sequence_str] = String.split(line, " ")
    sequence = String.split(sequence_str, ",") |> Enum.map(&String.to_integer/1)
    pattern = String.to_charlist(pattern)
    {pattern, sequence}
  end

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

  defp count([?# | record], sequence, false, 1) do
    count(record, sequence, true, 0)
  end

  defp count([?# | record], sequence, false, need_hashes) when need_hashes > 1 do
    count(record, sequence, false, need_hashes - 1)
  end

  defp count([?# | record], [run | sequence], false, 0) do
    count(record, sequence, run == 1, run - 1)
  end

  defp count([?. | record], sequence, _needs_dot, 0) do
    count(record, sequence, false, 0)
  end

  defp count([?. | _], _sequence, _needs_dot, need_hashes) when need_hashes > 0, do: 0

  defp count([?? | record], sequence, true, 0) do
    count(record, sequence, false, 0)
  end

  defp count([?? | record], [], false, 0) do
    count(record, [], false, 0)
  end

  defp count([?? | record], sequence, false, 1) do
    count(record, sequence, true, 0)
  end

  defp count([?? | record], sequence, false, need_hashes) when need_hashes > 1 do
    count(record, sequence, false, need_hashes - 1)
  end

  defp count([?? | record], [s | sequence], false, 0) do
    put_dot = count(record, [s| sequence], false, 0)
    put_hash = count(record, sequence, (s == 1), s - 1)
    # Debugging output to help understand branching decisions
    #    IO.puts("#{length(record)}: Branch: . => #{put_dot}, # => #{put_hash}; sequence; #{inspect([s | sequence])}")
    put_dot + put_hash
  end
end