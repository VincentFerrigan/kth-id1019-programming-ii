defmodule Expression do
  @moduledoc """
  Documentation for `Expression`.
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

  @spec run(expr(), map()) :: :ok
  def run(ast, env) do
    IO.write("Evaluate #{pretty_print(ast)}, \n where #{inspect(env)}.\n\n")
    IO.write("Result: #{pretty_print(eval(ast, env))}\n")

    # TODO replace inspect. Not directly pretty!!
    :ok
  end

  @spec eval(expr(), map()):: expr()
  def eval({:num, n}, _), do: {:num, n}
  def eval({:var, v}, env), do: {:num, Map.get(env, v)}
  def eval({:add, e1, e2}, env), do: addition(eval(e1, env), eval(e2, env))
  def eval({:sub, e1, e2}, env), do: subtraction(eval(e1, env), eval(e2, env))
  def eval({:mul, e1, e2}, env), do: multiplication(eval(e1, env), eval(e2, env))
  def eval({:div, e1, e2}, env), do: division(eval(e1, env), eval(e2, env))
  def eval({:q, a, 1}, env), do: eval({:num, a}, env)
  def eval({:q, a, b}, env) do
    division(eval({:num, a}, env), eval({:num, b}, env))
  end

  defp addition({:q, a, b}, {:q, c, d}), do: division({:num, a * d + b * c}, {:num, b * d})
  defp addition({:num, a}, {:q, c, d}), do: division({:num, a * d + 1 * c}, {:num, 1 * d})
  defp addition({:q, a, b}, {:num, c}), do: division({:num, a * 1 + b * c}, {:num, b * 1})
  defp addition({:num, a}, {:num, c}), do: {:num, a + c}

  defp subtraction({:q, a, b}, {:q, c, d}), do: division({:num, a * d - b * c}, {:num, b * d})
  defp subtraction({:num, a}, {:q, c, d}), do: division({:num, a * d - 1 * c}, {:num, 1 * d})
  defp subtraction({:q, a, b}, {:num, c}), do: division({:num, a * 1 - b * c}, {:num, b * 1})
  defp subtraction({:num, a}, {:num, c}), do: {:num, a - c}

  defp multiplication({:q, a, b}, {:q, c, d}), do: division({:num, a * c}, {:num, b * d})
  defp multiplication({:num, a}, {:q, c, d}), do: division({:num, a * c}, {:num, 1 * d})
  defp multiplication({:q, a, b}, {:num, c}), do: division({:num, a * c}, {:num, b * 1})
  defp multiplication({:num, a}, {:num, c}), do: {:num, a * c}

  defp division({:q, a, b}, {:q, c, d}) do
    multiplication({:q, a, b}, {:q, d, c})
  end
  defp division(_, {:num, 0}) do
    raise ArgumentError, message: "Attempted to divide by zero."
  end

  defp division({:num, n1}, {:num, n2}) do
    gcd = Integer.gcd(convert_float_to_int_if_whole(n1), convert_float_to_int_if_whole(n2))
    {:q, convert_float_to_int_if_whole(n1/gcd), convert_float_to_int_if_whole(n2/gcd)}
  end

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
  def pretty_print({:num, n}), do: "#{n}"
  def pretty_print({:var, v}), do: "#{v}"
  def pretty_print({:mul, {:num, n}, {:var, v}}), do: "#{n}#{v}"
  def pretty_print({:mul, {:var, v}, {:num, n}}), do: "#{n}#{v}"

  def pretty_print({:mul, {:num, -1}, e}), do: "-(#{pretty_print(e)})"
  def pretty_print({:mul, e, {:num, -1}}), do: "-(#{pretty_print(e)})"
  def pretty_print({:add, e1, e2}), do: "#{pretty_print(e1)} + #{pretty_print(e2)}"
  def pretty_print({:div, e1, e2}), do: "#{pretty_print(e1)}/#{pretty_print(e2)}"
  def pretty_print({:q, e1, e2}), do: "#{pretty_print(e1)}/#{pretty_print(e2)}"
  def pretty_print({:mul, e1, e2}), do: "#{pretty_print(e1)} * #{pretty_print(e2)}"

  @spec pretty_print(number()) :: String.t()
  def pretty_print(n), do: "#{n}"
end
