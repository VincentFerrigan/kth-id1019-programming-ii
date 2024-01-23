defmodule EnvList do
  @moduledoc """
  Documentation for `EnvList`.

  Provides functionalities for managing a simple environment list.
  This module allows the creation and manipulation of a key-value list,
  supporting operations such as adding, looking up, and removing elements.
  Each element in the list is a tuple containing a key and
  its value. The implementation ensures unique keys in the list.
  """

  @doc """
  Creates a new empty environment list.

  ## Examples

      iex> EnvList.new()
      []
  """
  @spec new() :: list()
  def new(), do: []

  @doc """
  Adds a key-value pair to the environment list. If the key already exists,
  its value is updated with the new value provided.

  ## Examples

      iex> EnvList.add([], :a, 1)
      [a: 1]

      iex> EnvList.add([a: 1], :a, 2)
      [a: 2]

      iex> EnvList.add([a: 1], :b, 2)
      [a: 1, b: 2]
  """
  @spec add(list(), any(), any()) :: list()
  def add([], key, value), do: [{key, value} | []]
  def add([{key, _} | tail], key, value), do: [{key, value} | tail]
  def add([pre_list | tail], key, value), do: [pre_list | add(tail, key, value)]

  @doc """
  Looks up the value for a given key in the environment list. Returns `nil` if the key is not found.

  ## Examples

      iex> EnvList.lookup([a: 1, b: 2], :a)
      {:a, 1}

      iex> EnvList.lookup([a: 1, b: 2], :c)
      :nil
  """
  @spec lookup(list(), any()) :: any()
  def lookup([], _), do: :nil
  def lookup([{key, value}| _], key), do:  {key, value}
  def lookup([ _ | tail ], key), do:  lookup(tail, key)

  @doc """
  Removes a key-value pair from the environment list based on the key provided.
  If the key is not found, the list is returned unchanged.

  ## Examples

      iex> EnvList.remove([a: 1, b: 2], :a)
      [b: 2]

       iex> EnvList.remove([a: 1, b: 2], :c)
       [{:a, 1}, {:b, 2}]
  """
  @spec remove(list(), any()) :: list()
  def remove([],_), do: :nil
  def remove([{key, _} | tail], key), do: tail
  def remove([pre_list | tail], key), do: [pre_list | remove(tail, key)]

end
