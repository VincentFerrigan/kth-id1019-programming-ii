defmodule Reduce do
  @moduledoc """
  Documentation for `Reduce`.
  """

  # MAP
  @spec inc([integer], integer) :: [integer]
  def inc([], _), do: []
  def inc([x|xs], n), do: [x+n|inc(xs, n)]

  @spec dec([integer], integer) :: [integer]
  def dec([], _), do: []
  def dec([x|xs], n), do: [x-n|dec(xs, n)]

  @spec mul([integer], integer) :: [integer]
  def mul([], _), do: []
  def mul([x|xs], n), do: [x*n|mul(xs, n)]

  @spec rrem([integer], integer) :: [integer]
  def rrem([], _), do: []
  def rrem([x|xs], n), do: [rem(x,n)|rrem(xs, n)]

  # SIMPLE REDUCE
  @spec simple_length([integer]) :: integer
  def simple_length([]), do: 0
  def simple_length([_|xs]), do: 1 + simple_length(xs)

  @spec simple_sum([integer]) :: integer
  def simple_sum([]), do: 0
  def simple_sum([x|xs]), do: x + simple_sum(xs)

  @spec simple_prod([integer]) :: integer
  def simple_prod([]), do: 1
  def simple_prod([x|xs]), do: x * simple_prod(xs)

  # REDUCE
  @spec acc_length([integer], integer) :: integer
  def acc_length(xs), do: acc_length(xs, 0)
  def acc_length([], acc), do: acc
  def acc_length([_|xs], acc), do: acc_length(xs, acc + 1)

  @spec acc_sum([integer] | [integer], integer) :: integer
  def acc_sum(xs), do: acc_sum(xs, 0)
  def acc_sum([], acc), do: acc
  def acc_sum([x|xs], acc), do: acc_sum(xs, acc + x)

  @spec acc_prod([integer] | [integer], integer) :: integer
  def acc_prod(xs), do: acc_prod(xs, 1)
  def acc_prod([], acc), do: acc
  def acc_prod([x|xs], acc), do: acc_prod(xs, acc * x)

  # FILTER
  @spec even([integer]):: [integer]
  def even(xs), do: even(xs, [])
  defp even([], acc), do: Enum.reverse(acc)
  defp even([x|xs], acc) do
    if is_even(x), do: even(xs, [x|acc]), else: even(xs, acc)
  end

  @spec odd([integer]):: [integer]
  def odd(xs), do: odd(xs, [])
  defp odd([], acc), do: Enum.reverse(acc)
  defp odd([x|xs], acc) do
    if is_odd(x), do: odd(xs, [x|acc]), else: odd(xs, acc)
  end

  @spec ddiv([integer], integer, [integer]) :: [integer]
  def ddiv(xs, n), do: ddiv(xs, n, [])
  defp ddiv([], _, acc), do: Enum.reverse(acc)
  defp ddiv([x|xs], n, acc) do
    if is_div(x, n), do: ddiv(xs, n, [x|acc]),else: ddiv(xs, n, acc)
  end

  # is_functions for filtering
  @spec is_even(integer) :: boolean
  defp is_even(n), do: rem(n, 2) == 0

  @spec is_odd(integer) :: boolean
  defp is_odd(n), do: rem(n, 2) != 0

  @spec is_div(integer, integer) :: boolean
  defp is_div(n, d), do: rem(n, d) == 0

end
