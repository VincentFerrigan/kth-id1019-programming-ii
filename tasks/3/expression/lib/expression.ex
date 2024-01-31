defmodule Expression do
  @moduledoc """
  Documentation for `Expression`.

  This module provides functionality for evaluating mathematical expressions,
  including operations like addition, subtraction, multiplication, and division.
  It supports handling literals (variables, whole numbers and rational numbers),
  ensuring correct arithmetic operations and simplification of expressions.
  """



  @typedoc """
  A `literal` in the expression. It can be:
    - `{:num, number()}`: A numeric literal.
    - `{:var, atom()}`: A variable represented by an atom.
    - `{:q, number(), number()}`: A quotient/rational number.
  """
  @type literal() :: {:num, number()} | {:var, atom() | {:q, number(), number()}}

  @typedoc """
  An expression `expr()` in the mathematical DSL. Expressions can be:
    - `{:add, expr(), expr()}`: Addition of two expressions.
    - `{:sub, expr(), expr()}`: Subtraction of two expressions.
    - `{:mul, expr(), expr()}`: Multiplication of two expressions.
    - `{:div, expr(), expr()}`: Division of two expressions.
    - `literal()`: A literal value.
  """
  @type expr() ::   {:add, expr(), expr()}
                  | {:sub, expr(), expr()}
                  | {:mul, expr(), expr()}
                  | {:div, expr(), expr()}
                  | literal()

  @doc """
  Evaluates and prints given expression based on provided environment.

  This function takes a mathematical expression represented in a structured format (as defined by the `expr()` type),
  and an environment,`env`, as a mapping of variables to their values.

  The given expression and the final simplified evaluation are pretty printed to the console.

  ## Examples

      iex> e = {:div, {:mul, {:num, 3}, {:var, :x}}, {:mul, {:num, 2}, {:var, :y}}}
      iex> Expression.run(e, %{x: 2, y: 4})
      "Evaluating 3x/2y, where %{x: 2, y: 4}.
      Result: 3/4"
      :ok
  """
  @spec run(expr(), map()) :: :ok
  def run(ast, env) do
    IO.write("Evaluating #{pretty_print(ast)}, where #{inspect(env)}.\n")
    IO.write("Result: #{pretty_print(eval(ast, env))}\n")

    # TODO replace inspect. Not directly pretty!!
    :ok
  end

  @doc """
  Evaluates the given expression based on the provided environment.
  It takes an expression as an abstract syntax tress, `ast`,
  and an environment,`env`, as a mapping of variables to their values.

  ## Examples

      iex> e = {:div, {:mul, {:num, 3}, {:var, :x}}, {:mul, {:num, 2}, {:var, :y}}}
      iex> Expression.eval(e, %{x: 2, y: 4})
      {:q, 3, 4}
  """
  #      iex> env = Map.put(Map.new(), :x, 2)
  @spec eval(expr(), map()):: literal()
  def eval({:num, n}, _), do: {:num, n}
  def eval({:var, v}, env), do: {:num, Map.get(env, v)}
  def eval({:add, e1, e2}, env), do: addition(eval(e1, env), eval(e2, env))
  def eval({:sub, e1, e2}, env), do: subtraction(eval(e1, env), eval(e2, env))
  def eval({:mul, e1, e2}, env), do: multiplication(eval(e1, env), eval(e2, env))
  def eval({:div, e1, e2}, env), do: division(eval(e1, env), eval(e2, env))
  def eval({:q, a, a}, env), do: eval({:num, 1}, env)
  def eval({:q, a, 1}, env), do: eval({:num, a}, env)
  def eval({:q, a, a}, env), do: eval({:num, 1}, env)
  def eval({:q, a, b}, env) do
    division(eval({:num, a}, env), eval({:num, b}, env))
  end

  # Performs addition between two expressions, handling both numeric and rational types.
  defp addition({:q, a, b}, {:q, c, d}), do: division({:num, a * d + b * c}, {:num, b * d})
  defp addition({:num, a}, {:q, c, d}), do: division({:num, a * d + 1 * c}, {:num, 1 * d})
  defp addition({:q, a, b}, {:num, c}), do: division({:num, a * 1 + b * c}, {:num, b * 1})
  defp addition({:num, a}, {:num, c}), do: {:num, a + c}

  # Performs subtraction between two expressions, handling both numeric and rational types.
  defp subtraction({:q, a, b}, {:q, c, d}), do: division({:num, a * d - b * c}, {:num, b * d})
  defp subtraction({:num, a}, {:q, c, d}), do: division({:num, a * d - 1 * c}, {:num, 1 * d})
  defp subtraction({:q, a, b}, {:num, c}), do: division({:num, a * 1 - b * c}, {:num, b * 1})
  defp subtraction({:num, a}, {:num, c}), do: {:num, a - c}

  # Performs multiplication between two expressions, handling both numeric and rational types.
  defp multiplication({:q, a, b}, {:q, c, d}), do: division({:num, a * c}, {:num, b * d})
  defp multiplication({:num, a}, {:q, c, d}), do: division({:num, a * c}, {:num, 1 * d})
  defp multiplication({:q, a, b}, {:num, c}), do: division({:num, a * c}, {:num, b * 1})
  defp multiplication({:num, a}, {:num, c}), do: {:num, a * c}


  # Performs division between two expressions, handling both numeric and rational types.
  # Raises an ArgumentError if an attempt is made to divide by zero.
  defp division({:q, a, b}, {:q, c, d}) do
    multiplication({:q, a, b}, {:q, d, c})
  end
  defp division(_, {:num, 0}) do
    raise ArgumentError, message: "Attempted to divide by zero."
  end

  defp division({:num, n}, {:num, n}), do: {:num, 1}
  defp division({:num, n}, {:num, 1}), do: {:num, n}
  defp division({:num, n1}, {:num, n2}) do
    # Simplifies the result by dividing both numerator and denominator by their GCD.
    gcd = Integer.gcd(convert_float_to_int_if_whole(n1), convert_float_to_int_if_whole(n2))
    {:q, convert_float_to_int_if_whole(n1/gcd), convert_float_to_int_if_whole(n2/gcd)}
  end

  # Converts a float to an integer if it's a whole number, otherwise raises an ArgumentError.
  defp convert_float_to_int_if_whole(float) do
    truncated = trunc(float)
    if truncated == float do
      truncated
    else
      raise ArgumentError, message: "Input #{float} is not a whole number and cannot be converted to an integer."
    end
  end

  # Pretty printing
  @spec pretty_print(expr()) :: String.t()
  defp pretty_print({:num, n}), do: "#{n}"
  defp pretty_print({:var, v}), do: "#{v}"
  defp pretty_print({:mul, {:num, n}, {:var, v}}), do: "#{n}#{v}"
  defp pretty_print({:mul, {:var, v}, {:num, n}}), do: "#{n}#{v}"

  defp pretty_print({:mul, {:num, -1}, e}), do: "-(#{pretty_print(e)})"
  defp pretty_print({:mul, e, {:num, -1}}), do: "-(#{pretty_print(e)})"
  defp pretty_print({:add, e1, e2}), do: "#{pretty_print(e1)} + #{pretty_print(e2)}"
  defp pretty_print({:div, e1, e2}), do: "#{pretty_print(e1)}/#{pretty_print(e2)}"
  defp pretty_print({:q, e1, e2}), do: "#{pretty_print(e1)}/#{pretty_print(e2)}"
  defp pretty_print({:mul, e1, e2}), do: "#{pretty_print(e1)} * #{pretty_print(e2)}"

  @spec pretty_print(number()) :: String.t()
  defp pretty_print(n), do: "#{n}"
end