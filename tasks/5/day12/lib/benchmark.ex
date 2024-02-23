defmodule Benchmark do
  def run(input \\ "./input/test.txt", multipliers \\ [1,2,3,4,5,6,7]) do
    # Initialize or clear the file content before appending new benchmark results
    File.write!("./data/benchmark_results.dat", "Multiplier, Brute_force (μs), Dynamic (μs)\n")

    Enum.each(multipliers, fn multiplier ->
      IO.puts("Benchmarking with multiplier: #{multiplier}")

      # Benchmark Part I with the updated function
      {time_sample, _result_part_1} = :timer.tc(Day12, :part_1, [input, multiplier])
      IO.puts("part_1/2 took: #{time_sample} microseconds")

      # Benchmark Part II
      {time_dynamic, _result_part_2} = :timer.tc(Day12, :part_2, [input, multiplier])
      IO.puts("part_2/2 took: #{time_dynamic} microseconds")

      # Write results to DAT
      File.write!("./data/benchmark_results.dat", "#{multiplier},#{time_sample},#{time_dynamic}\n", [:append])

      IO.puts("") # For better readability in output
    end)
    IO.puts("Benchmarking complete. Results saved to benchmark_results.dat")
  end

  def run_2(input \\ "./input/test.txt", multipliers \\ [1, 2, 3, 4, 5, 6, 7]) do
    # Initialize or clear the file content before appending new benchmark results
    File.write!("./data/benchmark_results_2.dat", "Multiplier, Brute_force (μs), Dynamic (μs)\n")

    # Initialize a list to store Part I results
    brute_force_times = Enum.map(multipliers, fn multiplier ->
      IO.puts("Benchmarking Part I with multiplier: #{multiplier}")

      # Benchmark Part I
      {time_sample, _result_part_1} = :timer.tc(Day12, :part_1, [input, multiplier])
      IO.puts("part_1/2 took: #{time_sample} microseconds")

      # Return the execution time for this iteration
      {multiplier, time_sample}
    end)

    # Initialize a list to store Part II results
    dynamic_times = Enum.map(multipliers, fn multiplier ->
      IO.puts("Benchmarking Part II with multiplier: #{multiplier}")

      # Benchmark Part II
      {time_dynamic, _result_part_2} = :timer.tc(Day12, :part_2, [input, multiplier])
      IO.puts("part_2/2 took: #{time_dynamic} microseconds")

      # Return the execution time for this iteration
      {multiplier, time_dynamic}
    end)

    # Now, write the combined results to the file
    Enum.zip(brute_force_times, dynamic_times)
    |> Enum.each(fn {{multiplier, time_sample}, {_, time_dynamic}} ->
      File.write!("./data/benchmark_results_2.dat", "#{multiplier},#{time_sample},#{time_dynamic}\n", [:append])
    end)

    IO.puts("Benchmarking complete. Results saved to benchmark_results.dat")
  end
end

#defmodule Benchmark do
#  def run(input \\"./input/test.txt", multipliers \\ [2,4,8,16,32]) do
##    input = "????.######..#####. 1,6,5" # Example input, adjust as necessary
##    multipliers = [2, 4, 8, 16, 32]
#    File.write!("benchmark_results.dat", "Multiplier, Brute_force (μs), Dynamic (μs)\n", [:append])
#
#    Enum.each(multipliers, fn multiplier ->
#      IO.puts("Benchmarking with multiplier: #{multiplier}")
#
#      # Benchmark Part I
#      {time_sample, _result_part_1} = :timer.tc(Day12, :part_1, [input, multiplier])
#      IO.puts("part_1/2 took: #{time_sample} microseconds")
#
#      # Benchmark Part II
#      {time_dynamic, _result_part_2} = :timer.tc(Day12, :part_2, [input, multiplier])
#      IO.puts("part_2/2 took: #{time_dynamic} microseconds")
#
#      # Write results to DAT
#      File.write!("benchmark_results.dat", "#{multiplier},#{time_sample},#{time_dynamic}\n", [:append])
#
#      IO.puts("") # For better readability in output
#    end)
#    IO.puts("Benchmarking complete. Results saved to benchmark_results.dat")
#  end
#end