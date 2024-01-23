defmodule Benchmark do
  @moduledoc """
  Provides functionality to benchmark different key-value store implementations.
  This includes a Map wrapper and functions to benchmark list and tree-based
  implementations against Elixir's native Map implementation.
  """

  defmodule MapWrapper do
    @moduledoc """
    A wrapper module for Elixir's Map to provide a consistent interface with
    add, lookup, and remove functions for benchmarking purposes.
    """
    def new(), do: %{}
    def add(map, key, value), do: Map.put(map, key, value)
    def lookup(map, key), do: Map.get(map, key)
    def remove(map, key), do: Map.delete(map, key)
  end

  @doc """
  Runs the benchmark for all implementations with the given operation count.
  """
  @spec run(integer()) :: :ok
  def run(n) do
    sizes = [16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192]

    :io.format("# Benchmark with ~w operations,\n time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

    # Benchmark for List-based implementation
    :io.format("List\n")
    benchmark(EnvList, sizes, n)

    # Benchmark for Tree-based implementation
    :io.format("Tree\n")
    benchmark(EnvTree, sizes, n)

    # Benchmark for Built-in map
    :io.format("Map\n")
    benchmark(MapWrapper, sizes, n)
  end

  @doc """
  Conducts a benchmark on a specific data structure implementation.
    ## Parameters
  - `impl_module`: The module implementing the data structure to benchmark.
  - `sizes`: A list of sizes for which to run the benchmark.
  - `n`: The number of operations to perform in each benchmark.
  """
  @spec benchmark(module(), list(integer()), integer()) :: :ok
  def benchmark(impl_module, sizes, n) do
    Enum.each(sizes, fn (i) ->
      {i, t_add, t_lookup, t_remove} = benchmark_impl(impl_module, i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n",
        [i, t_add/n, t_lookup/n, t_remove/n])
    end)
  end

  @doc """
  Performs the benchmarking of add, lookup, and remove operations for a given
  implementation module, size, and operation count.
  """
  @spec benchmark_impl(module(), integer(), integer()) :: {integer(), integer(), integer(), integer()}
  def benchmark_impl(impl_module, i, n) do
    # Generate a sequence of random keys
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)

    # Populate the data structure with initial key-value pairs
    # This forms the basis for the subsequent benchmarking operations
    data_structure = Enum.reduce(seq, impl_module.new(), fn(e, acc) ->
      impl_module.add(acc, e, :foo)
    end)

    # Generate a new sequence of random keys for the benchmarking operations
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)

    # Measure the time taken to add elements to the data structure
    # This benchmarks the efficiency of the add operation
    {add_time, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        impl_module.add(data_structure, e, :foo)
      end)
    end)

    # Measure the time taken to lookup elements in the data structure
    # This benchmarks the efficiency of the lookup operation
    {lookup_time, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        impl_module.lookup(data_structure, e)
      end)
    end)

    # Measure the time taken to remove elements from the data structure
    # This benchmarks the efficiency of the remove operation
    {remove_time, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        impl_module.remove(data_structure, e)
      end)
    end)

    # Return the size, and the times for add, lookup, and remove operations
    {i, add_time, lookup_time, remove_time}
  end
end