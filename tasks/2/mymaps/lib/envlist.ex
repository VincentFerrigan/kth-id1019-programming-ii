defmodule EnvList do
  @moduledoc """
  Documentation for `EnvList`.
  """

  @spec new() :: list()
  def new(), do: []

  @spec add(list(), atom(), any()) :: list()
  def add([], key, value), do: [{key, value} | []]
  def add([{key, _} | tail], key, value), do: [{key, value} | tail]
  def add([pre_list | tail], key, value), do: [pre_list | add(tail, key, value)]

  @spec lookup(list(), atom()) :: any()
  def lookup([], _), do: nil
  def lookup([{key, value}| _], key), do:  {key, value}
  def lookup([ _ | tail ], key), do:  lookup(tail, key)


  @spec remove(list(), atom()) :: list()
  def remove([],_), do: nil
  def remove([{key, _} | tail], key), do: tail
  def remove([pre_list | tail], key), do: [pre_list | remove(tail, key)]

end
