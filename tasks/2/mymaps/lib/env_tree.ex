defmodule EnvTree do
  @moduledoc """
  Documentation for `EnvTree`.

  Provides functionalities for managing a binary search tree.
  This module allows for the creation and manipulation of a key-value binary search tree,
  supporting operations such as adding, looking up, and removing elements.
  Each node in the tree is a tuple {:node, key, value, left, right}, where 'key' is an atom,
  'value' is any type, and 'left' and 'right' are the left and right subtrees, respectively.
  """

  @doc """
  Creates a new empty binary search tree.

  ## Examples

      iex> EnvTree.new()
      nil
  """
  @spec new() :: list()
  def new() do :nil end

  @doc """
  Adds a key-value pair to the binary search tree. If the key already exists,
  its value is updated.

  ## Examples

      iex> EnvTree.add(nil, :a, 1)
      {:node, :a, 1, nil, nil}
  """
  @spec add(tuple(), atom(), any()) :: tuple()
  def add(:nil, key, value), do: {:node, key, value, :nil, :nil}
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end
  def add({:node, k, v, left, right}, key, value) when key < k do
    {:node, k, v, add(left, key, value), right}
  end
  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end

  @doc """
  Looks up the value for a given key in the binary search tree.
  Returns either the key with its value `{key, value}`
  or `:nil` if the key is not found.

  ## Examples

      iex> EnvTree.lookup({:node, :a, 1, nil, nil}, :a)
      {:a, 1}

      iex> EnvTree.lookup(nil, :b)
      nil
  """
  @spec lookup(tuple(), atom()) :: tuple()
  def lookup(:nil, _), do: :nil
  def lookup({:node, key, value, _, _} , key), do: {key, value}
  def lookup({:node, k, _, left, _}, key) when key < k, do: lookup(left, key)
  def lookup({:node, _, _, _, right}, key), do: lookup(right, key)


  @doc """
  Removes a key-value pair from the binary search tree based on the key provided.
  If the key is not found, the tree is returned unchanged.

  ## Examples

      iex> EnvTree.remove({:node, :a, 1, nil, nil}, :a)
      nil
  """
  @spec remove(tuple(), atom()) :: tuple()
  def remove(:nil, _), do: :nil
  def remove({:node, key, _, :nil, right}, key), do: right
  def remove({:node, key, _, left, nil}, key), do: left
  def remove({:node, key, _, left, right}, key) do
    {k, val, right} = leftmost(right)
    {:node, k, val, left, right}
  end
  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, remove(left, key), right}
  end
  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, remove(right, key)}
  end

  # Private helper function
  defp leftmost({:node, key, value, :nil, right}) do
    # When the left subtree is empty (`:nil`),
    # this function returns the current node's key and value,
    # along with the right subtree.
    # This is used to find the minimum value in a subtree.
    {key, value, right}
  end
  defp leftmost({:node, k, v, left, right}) do
    # Recursively traverses the left subtree to find the leftmost (minimum) node.
    # Once the leftmost node is found, it returns the key and value of that node,
    # along with the adjusted subtree that excludes this leftmost node.
    # This is essential for the remove operation in a binary search tree,
    # especially when the node to be removed has two children.
    {key, value, rest} = leftmost(left)
    {key, value, {:node, k, v, rest, right}}
  end
end
