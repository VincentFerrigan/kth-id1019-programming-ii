defmodule Reduce do
  @moduledoc """
  This Elixir module embodies the essence of functional programming
  by offering a comprehensive suite of list manipulation operations.
  It is meticulously designed to facilitate both elementary and advanced
  operations on lists of integers, encapsulating the principles of mapping,
  reduction, and filtering.

  Part 1 of the module introduces foundational map functions that allow for
  the transformation of list elements through incrementing, decrementing,
  multiplication, and modulo operations.
  It progresses to illustrate simple and tail-recursive reduction techniques,
  adeptly calculating the length, sum, and product of lists,
  showcasing efficiency and elegance in handling list accumulations.

  Part 2 elevates the functional programming paradigm by incorporating
  generic versions of map, reduce, and filter operations.
  These generic functions exemplify the power of higher-order functions,
  enabling dynamic operation application over lists based on passed-in
  predicates or transformations.

  The module culminates in demonstrating function composition through a
  practical example that seamlessly combines filtering, mapping,
  and reduction to solve a complex problem, illustrating the module's
  capability to compose operations elegantly.

  This module serves as both a toolkit for practical list manipulation
  tasks and a pedagogical resource for understanding and applying
  functional programming concepts in Elixir.
  """

  # PART 1
  # MAP FUNCTIONS
  # Mapping functions to increment, decrement, multiply,
  # and get remainder for each element in a list.

  @doc """
  Increments each element in the list by `n`.
  """
  @spec map_inc([integer], integer) :: [integer]
  def map_inc([], _n), do: []
  def map_inc([x|xs], n), do: [x+n|map_inc(xs, n)]

  @doc """
  Decrements each element in the list by `n`.
  """
  @spec map_dec([integer], integer) :: [integer]
  def map_dec([], _n), do: []
  def map_dec([x|xs], n), do: [x-n|map_dec(xs, n)]

  @doc """
  Multiplies each element in the list by `n`.
  """
  @spec map_mul([integer], integer) :: [integer]
  def map_mul([], _n), do: []
  def map_mul([x|xs], n), do: [x*n|map_mul(xs, n)]

  @doc """
    @doc """
  Applies the remainder operation on each element in the list with `n`.
  """
  @spec map_rem([integer], integer) :: [integer]
  def map_rem([], _n), do: []
  def map_rem([x|xs], n), do: [rem(x,n)|map_rem(xs, n)]

  # SIMPLE REDUCE FUNCTIONS
  # Simple reduction functions to find length, sum, and product of a list.

  @doc """
  Calculates the length of the list.
  """
  @spec simple_reduce_length([integer]) :: integer
  def simple_reduce_length([]), do: 0
  def simple_reduce_length([_x|xs]), do: 1 + simple_reduce_length(xs)

  @doc """
  Calculates the sum of all elements in the list.
  """
  @spec simple_reduce_sum([integer]) :: integer
  def simple_reduce_sum([]), do: 0
  def simple_reduce_sum([x|xs]), do: x + simple_reduce_sum(xs)

  @doc """
  Calculates the product of all elements in the list.
  """
  @spec simple_reduce_prod([integer]) :: integer
  def simple_reduce_prod([]), do: 1
  def simple_reduce_prod([x|xs]), do: x * simple_reduce_prod(xs)

  # TAIL RECURSIVE REDUCE FUNCTIONS
  # Tail-recursive reduction functions with an accumulator for efficient length, sum, and product calculations.

  @doc """
  Calculates the length of a list using tail recursion.
  """
  @spec acc_reduce_length([integer], integer) :: integer
  def acc_reduce_length(xs), do: acc_reduce_length(xs, 0)
  def acc_reduce_length([], acc), do: acc
  def acc_reduce_length([_x|xs], acc), do: acc_reduce_length(xs, acc + 1)

  @doc """
  Tail-recursive approach to calculate the sum of elements in the list.
  """
  @spec acc_reduce_sum([integer] | [integer], integer) :: integer
  def acc_reduce_sum(xs), do: acc_reduce_sum(xs, 0)
  def acc_reduce_sum([], acc), do: acc
  def acc_reduce_sum([x|xs], acc), do: acc_reduce_sum(xs, acc + x)

  @doc """
  Tail-recursive approach to calculate the product of elements in the list.
  """
  @spec acc_reduce_prod([integer]) :: integer
  def acc_reduce_prod(xs), do: acc_reduce_prod(xs, 1)

  @spec acc_reduce_prod([integer], integer) :: integer
  defp acc_reduce_prod([], acc), do: acc
  defp acc_reduce_prod([x|xs], acc), do: acc_reduce_prod(xs, acc * x)

  # FILTER FUNCTIONS
  # Filter functions to select even, odd, and divisible numbers from a list.

  @doc """
  Filters even numbers from the list.
  """
  @spec filter_even([integer]):: [integer]
  def filter_even(xs), do: filter_even(xs, [])

  # Private filter function for even numbers with accumulator.
  @spec filter_even([integer], [integer]):: [integer]
  defp filter_even([], acc), do: Enum.reverse(acc)
  defp filter_even([x|xs], acc) do
    if rem(x,2) == 0, do: filter_even(xs, [x|acc]), else: filter_even(xs, acc)
  end

  @doc """
  Filters odd numbers from the list.
  """
  @spec filter_odd([integer]):: [integer]
  def filter_odd(xs), do: filter_odd(xs, [])

  # Private filter function for odd numbers with accumulator.
  @spec filter_odd([integer], [integer]):: [integer]
  defp filter_odd([], acc), do: Enum.reverse(acc)
  defp filter_odd([x|xs], acc) do
    if rem(x,2) != 0, do: filter_odd(xs, [x|acc]), else: filter_odd(xs, acc)
  end

  @doc """
  Filters numbers divisible by n from a list.
  """
  @spec filter_div([integer], [integer]):: [integer]
  def filter_div(xs, n), do: filter_div(xs, n, [])

  #Private filter function for divisibility with accumulator.
  @spec filter_div([integer], integer, [integer]) :: [integer]
  defp filter_div([], _n, acc), do: Enum.reverse(acc)
  defp filter_div([x|xs], n, acc) do
    if rem(x, n) == 0, do: filter_div(xs, n, [x|acc]),
                       else: filter_div(xs, n, acc)
  end

#  #  HELPER FUNCTIONS FOR FILTERING
##  These functions provide basic boolean checks used in filtering.
#  @spec is_even(integer) :: boolean
#  defp is_even(n), do: rem(n, 2) == 0
#
#  @spec is_odd(integer) :: boolean
#  defp is_odd(n), do: rem(n, 2) != 0
#
#  @spec is_div(integer, integer) :: boolean
#  defp is_div(n, d), do: rem(n, d) == 0


  # PART 2
  @doc """
  Applies a given function to each element of the list.

  ## Parameters:
  - `list`: The list of elements to be transformed.
  - `func`: The function to apply to each element of the list.

  ## Examples:
      iex> Reduce.map([1, 2, 3], fn x -> x * 2 end)
      [2, 4, 6]
  """
  @spec map([A], (A -> B)) :: [B]
  def map([], _func), do: []
  def map([x | xs], func) do
    [func.(x) | map(xs, func)]
  end

  @doc """
  Reduces a list to a single value by applying a function to each element and an accumulator.

  The function `func` is called with two arguments: the current accumulator
  and each element of the list.
  The result of `func` becomes the new accumulator value. The process repeats
  for each element in the list, starting with the initial value of `acc`.

  ## Parameters

    - `list`: The list to reduce.
    - `acc`: The initial accumulator value.
    - `func`: The function applied to each element and the accumulator.

  ## Examples

      iex> Reduce.reduce([1, 2, 3], 0, fn acc, x -> acc + x end)
      6

  """
  @spec reduce([A], B, (A, B -> B)) :: B
  def reduce([], acc, _func), do: acc
  def reduce([x | xs], acc, func) do
    reduce(xs, func.(x, acc), func)
  end

  @doc """
  Filters a list by applying a predicate function to each element, returning those for which the function returns `true`.

  ## Parameters:
  - `list`: The list of elements to filter.
  - `func`: The predicate function to apply to each element. It should return a boolean value.

  ## Examples:
      iex> Reduce.filter([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
      [2, 4]
  """
  @spec filter([A], (A -> boolean)) :: [A]
  def filter([], _func), do: []
  def filter([x | xs], func) do
    if func.(x), do: [x | filter(xs, func)],
                 else: filter(xs, func)
  end

  ## Function composition with piping
  @doc """
  Calculates the sum of the squares of all elements in the list
  that are less than `n`.

  This function demonstrates function composition with piping
  in Elixir


  ## Parameters:
  - `list`: The list of integers to process.
  - `n`: The threshold value. Only elements less than `n` are considered.

  ## Examples:
      iex> Reduce.sum_of_squares_below([1, 2, 3, 4, 5], 4)
      14 # Explanation: 1*1 + 2*2 + 3*3 = 14, since 4 and 5 are excluded

  """
  @spec sum_of_squares_below([integer], integer) :: integer
  def sum_of_squares_below(list, n) do
    list
    |> Reduce.filter(&(&1 < n)) # filter values less than n
    |> Reduce.map(&(&1 * &1))     # square each value
    |> Reduce.reduce(0, fn x, acc -> x + acc end) # sum them
  end
end
