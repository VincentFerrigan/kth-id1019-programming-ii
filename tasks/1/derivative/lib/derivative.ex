defmodule Derivative do
  @moduledoc """
  Documentation for `Derivative`.
  """

  @typedoc """
  A `literal` in the expression. It can be:
    - `{:num, number()}`: A numeric literal.
    - `{:var, atom()}`: A variable represented by an atom.
  """
  @type literal() :: {:num, number()} | {:var, atom()}

  @typedoc """
  An expression `expr()` in the mathematical DSL. Expressions can be:
    - `{:add, expr(), expr()}`: Addition of two expressions.
    - `{:mul, expr(), expr()}`: Multiplication of two expressions.
    - `{:pow, expr(), literal()}`: An expression raised to a literal power.
    - `{:ln, expr()}`: Natural logarithm of an expression.
    - `{:div, expr(), expr()}`: Division of two expressions.
    - `{:sin, expr()}`: Sine of an expression.
    - `{:cos, expr()}`: Cosine of an expression.
    - `{:sqrt, expr()}`: Square root of an expression.
    - `literal()`: A literal value.
  """
  @type expr() :: {:add, expr(), expr()}
                | {:mul, expr(), expr()}
                | {:pow, expr(), literal()}
                | {:ln, expr()}
                | {:div, expr(), expr()}
                | {:sin, expr()}
                | {:cos, expr()}
                | {:sqrt, expr()}
                | literal()

  @doc """
  Calculates and prints the derivative of a given mathematical expression,
  along with its simplified form and calculated value at a specific point.

  This function takes a mathematical expression represented in a structured format (as defined by the `expr()` type),
  a variable as an `atom()`, and a numeric value.
  It computes the derivative of the expression with respect to the given variable, simplifies this derivative,
  calculates its value at the specified number, and then simplifies this calculated value.
  The original derivative, its simplified form, and the final simplified calculated value are printed to the console.

  ## Parameters

    - `ast`: The mathematical expression to be differentiated (type `expr()`).
    - `variable`: The variable (as an `atom()`) with respect to which the derivative is to be taken.
    - `value`: The numeric value at which the derivative is to be evaluated.

  ## Returns

    - `:ok` on successful execution.

  ## Examples

  iex> Derivative.run({:add, {:num, 7}, {:pow, {:var, :x}, {:num, 2}}}, :x, 3)
  The steps taken to find the derivative of function 7 + (x)^2,
  at given value of x = 3.

  Derivative: 0 + (1 * (2 * (x)^1))
  Simplified: 2x
  Calculated: 6
  :ok
  """
  @spec run(expr(), atom(), number()) :: :ok
  def run(ast, variable, value) do
    derivative_of_function = find_derivative(ast, variable)
    simplification =  simplify(derivative_of_function)
    result = simplify(calculate(simplification, variable, value))

    IO.write("The steps taken to find the derivative of function \
#{pretty_print(ast)}, \nat given value of x = #{value}.\n\n")
    IO.write("Derivative: #{pretty_print(derivative_of_function)}\n")
    IO.write("Simplified: #{pretty_print(simplification)}\n")
    IO.write("Calculated: #{pretty_print(result)}\n")
    :ok
  end

  @spec find_derivative(expr(), atom()) :: expr()
  # The derivative of a constant is zero c = 0
  def find_derivative({:num, _}, _), do: {:num, 0}

  # The derivative of a variable with respect to itself is 1
  def find_derivative({:var, v}, v), do: {:num, 1}

  # The derivative of a constant (i.e. other variable with respect to v) is zero
  def find_derivative({:var, _}, _), do: {:num, 0}

  # Sum Rule: f + g 	f’ + g’
  def find_derivative({:add, e1, e2}, v), do: {:add, find_derivative(e1, v), find_derivative(e2, v)}

  # Product Rule: (fg)’ = f g’ + f’ g
  def find_derivative({:mul, e1, e2}, v) do
    {:add,
      {:mul, e1, find_derivative(e2, v)},
      {:mul, find_derivative(e1, v), e2}
    }
  end

# Quotient rule
  def find_derivative({:div, e1, e2}, v) do
    {:div,
      {:add,
        {:mul, find_derivative(e1, v), e2},
        {:mul,
          {:num, -1},
          {:mul, e1, find_derivative(e2, v)}
       }
      },
      {:pow, e2, {:num, 2}}
    }
  end

  # Power Rule: f^n = nf^(n−1)f'
  def find_derivative({:pow, e, {:num, n}}, v) do
    {:mul,
      find_derivative(e, v),
      {:mul,
        {:num, n},
        {:pow, e, {:num, n-1}}
      }
    }
  end

#  Logarithms ln(x) = 1/x
def find_derivative({:ln, e}, v), do: {:div, find_derivative(e, v), e}

#  Square Root √x = 	(½)x-½
def find_derivative({:sqrt, e}, v) do
    {:div,
      find_derivative(e, v),
      {:mul, {:num, 2}, {:sqrt, e}}
    }
end

#  Trigonometry (x is in radians)
  def find_derivative({:sin, e}, v) do
    {:mul, find_derivative(e, v), {:cos, e}}
  end

  def find_derivative({:cos, e}, v) do
    {:mul,
      {:num, -1},
      {:mul,
        find_derivative(e, v),
        {:sin, e}
      }
    }
  end

  @spec simplify(expr()) :: expr()
  def simplify({:num, n}),      do: ({:num, n})
  def simplify({:var, v}),      do: ({:var, v})

  def simplify({:add, e1, e2}), do: simplify_add(simplify(e1), simplify(e2))
  def simplify({:mul, e1, e2}), do: simplify_mul(simplify(e1), simplify(e2))
  def simplify({:div, e1, e2}), do: simplify_div(simplify(e1), simplify(e2))
  def simplify({:pow, e1, e2}), do: simplify_pow(simplify(e1), e2)
  def simplify({:ln, e}),       do: simplify_ln(simplify(e))
  def simplify({:sqrt, e}),     do: simplify_sqrt(simplify(e))
  def simplify({:sin, e}),      do: {:sin, simplify(e)}
  def simplify({:cos, e}),      do: {:sin, simplify(e)}
  def simplify(e),              do: e

  # add
  def simplify_add({:num, 0}, e), do: simplify(e)
  def simplify_add(e, {:num, 0}), do: simplify(e)
  def simplify_add({:num, n1}, {:num, n2}), do: {:num, n1 + n2}
  def simplify_add({:var, v}, {:var, v}), do: {:mul, {:num, 2}, {:var, v}}
  def simplify_add(e1, e2), do: {:add, e1, e2}

  # mul
  def simplify_mul({:num, 0}, _), do: {:num,0}
  def simplify_mul(_, {:num, 0}), do: {:num,0}
  def simplify_mul({:num, 1}, e), do: e
  def simplify_mul(e, {:num, 1}), do: e
  def simplify_mul({:num, n1}, {:num, n2}), do: {:num, n1 * n2}
  def simplify_mul({:var, v}, {:var, v}), do: {:pow, {:var, v}, {:num, 2}}
  def simplify_mul(e1, e2), do: {:mul, e1, e2}

  # div
  #  division
  def simplify_div(e, {:num, 1}), do: e
#  def simplify_div({:num, n1}, {:num, n2}), do: {:num, n1 / n2}
#  def simplify_div({l, _}, {_, l}), do: {:num, 1}
  def simplify_div(e1, e2), do: {:div, e1, e2}

  # pow
  def simplify_pow(_, {:num, 0}), do: {:num, 1}
  def simplify_pow(e, {:num, 1}), do: e
  def simplify_pow({:pow, e, {:num, n1}}, {:num, n2}), do: simplify({:pow, e, {:num, n1 * n2}})
  def simplify_pow({:num, n1}, {:num, n2}), do: {:num, :math.pow(n1, n2)}
  def simplify_pow(e1, e2), do: {:pow, e1, e2}

  # ln
  def simplify_ln({:num, 1}), do: {:num, 0}
  def simplify_ln({:num, 0}), do: {:num, 0}
  def simplify_ln(e), do: {:ln, e}

  # sqrt
  def simplify_sqrt({:num, n}), do: {:num, :math.sqrt(n)}
  def simplify_sqrt(e), do: {:sqrt, e}

  # Pretty printing
  @spec pretty_print(expr()) :: string()
  def pretty_print({:num, n}), do: "#{n}"
  def pretty_print({:var, v}), do: "#{v}"
#  def pretty_print({:mul, {:num, -1}, {:var, v}}), do: "-#{v}"
#  def pretty_print({:mul, {:var, v}, {:num, -1}}), do: "-#{v}"
  def pretty_print({:mul, {:num, n}, {:var, v}}), do: "#{n}#{v}"
  def pretty_print({:mul, {:var, v}, {:num, n}}), do: "#{n}#{v}"

  def pretty_print({:mul, {:num, -1}, e}), do: "-(#{pretty_print(e)})"
  def pretty_print({:mul, e, {:num, -1}}), do: "-(#{pretty_print(e)})"
#  def pretty_print({:mul, {:num, n}, e}), do:  "#{n}#{pretty_print(e)}"
#  def pretty_print({:mul, e, {:num, n}}), do: "#{n}#{pretty_print(e)}"

  def pretty_print({:add, e1, e2}), do: "#{pretty_print(e1)} + #{pretty_print(e2)}"
  def pretty_print({:div, e1, e2}), do: "(#{pretty_print(e1)}/#{pretty_print(e2)})"
  def pretty_print({:mul, e1, e2}), do: "(#{pretty_print(e1)} * #{pretty_print(e2)})"
  def pretty_print({:pow, e1, e2}), do: "(#{pretty_print(e1)})^#{pretty_print(e2)}"

  def pretty_print({:ln, e}), do: "ln(#{pretty_print(e)})"
  def pretty_print({:sqrt, e}), do: "sqrt(#{pretty_print(e)})"
  def pretty_print({:sin, e}), do: "sin(#{pretty_print(e)})"
  def pretty_print({:cos, e}), do: "cos(#{pretty_print(e)})"


  @spec calculate(expr(), atom(), number()) :: expr()
  def calculate({:num, n}, _, _), do: {:num, n}
  def calculate({:var, v}, v, n), do: {:num, n}
  def calculate({:var, v}, _, _), do: {:num, v}
  def calculate({:add, e1, e2}, v, n), do: {:add, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:mul, e1, e2}, v, n), do: {:mul, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:pow, e1, e2}, v, n), do: {:pow, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:ln, e}, v, n), do: {:ln, calculate(e, v, n)}
  def calculate({:div, e1, e2}, v, n), do: {:div, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:sqrt, e}, v, n), do: {:sqrt, calculate(e, v, n)}
  def calculate({:sin, e}, v, n), do: {:sin, calculate(e, v, n)}
  def calculate({:cos, e}, v, n), do: {:cos, calculate(e, v, n)}

end
