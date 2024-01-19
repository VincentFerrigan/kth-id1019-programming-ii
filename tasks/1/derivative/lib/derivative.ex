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
  The derivative of function 7 + x^2 at given value of x = 3.
  Derivative: 0 + 2x^1
  Simplified: 2x
  Calculated: 6
  :ok
  """
  @spec run(expr(), atom(), number()) :: :ok
  def run(ast, variable, value) do
    derivative_of_function = find_derivative(ast, variable)
    simplification =  simplify(derivative_of_function)
    result = simplify(calculate(simplification, variable, value))

    IO.write("The derivative of function #{pretty_print(ast)}
    at given value of x = #{value}.\n")
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

  # Power Rule: x^n = nx^(n−1)
  def find_derivative({:pow, {:var, v}, {:num, n}}, v) do
    {:mul,
      {:num, n},
      {:pow, {:var, v}, {:num, n-1}}
    }
  end

  # Division rule (a bit unsure)
  def find_derivative({:div, {:num, 1}, e}, v) do
      find_derivative({:pow, e, {:num, -1}}, v)
  end

#  def find_derivative({:div, {:num, n}, e}, v) do
# # Something
#  end

#  def find_derivative({:div, e1, e2}, v) do
#    {:div,
#      {:add,
#        {:mul, find_derivative(e1, v), e2},
#        {:mul,
#          {:mul, e1, find_derivative(e2, v)},
#          {:num, -1}
#        }
#      },
#      {:pow, e2, {:num, 2}}
#    }
#  end

  # Power Rule: f^n = nf^(n−1)f'
  def find_derivative({:pow, e, {:num, n}}, v) do
    {:mul,
      {:mul,
        {:num, n},
        {:pow, e, {:num, n-1}}
      },
    find_derivative(e, v)
   }
  end


#  Logarithms ln(x) = 1/x
def find_derivative({:ln, e}, v), do: {:pow, find_derivative(e, v), {:num, -1}}
#def find_derivative({:ln, e}, v) do
#  {:mul,
#    {:pow, e, {:num, -1}},
#    find_derivative(e, v)
#  }
#end

#  Square Root √x = 	(½)x-½
def find_derivative({:sqrt, e}, v) do
  find_derivative({:pow, e, {:num, 0.5}}, v)
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
  def simplify({:pow, e1, e2}), do: simplify_exp(simplify(e1), simplify(e2))
  def simplify({:sqrt, e}),     do: simplify_sqrt(simplify(e))
  def simplify({:mul, e1, e2}), do: simplify_mul(simplify(e1), simplify(e2))
  def simplify({:div, e1, e2}), do: simplify_div(simplify(e1), simplify(e2))
  def simplify({:add, e1, e2}), do: simplify_add(simplify(e1), simplify(e2))
  def simplify({:sin, e}),      do: {:sin, simplify(e)}
  def simplify({:cos, e}),      do: {:sin, simplify(e)}
  def simplify(e),              do: e

  # exp
  def simplify_exp(_, {:num, 0}), do: {:num, 1}
  def simplify_exp(e, {:num, 1}), do: simplify(e)
  def simplify_exp({:num, n1}, {:num, n2}), do: {:num, :math.pow(n1, n2)}
  #  def simplify_exp(e1, e2), do: {:pow, e1, e2}
  def simplify_exp(e1, e2), do: {:pow, simplify(e1), simplify(e2)}

  # mul
  def simplify_mul({:num, 0}, _), do: {:num,0}
  def simplify_mul(_, {:num, 0}), do: {:num,0}
  def simplify_mul({:num, 1}, e), do: simplify(e)
  def simplify_mul(e, {:num, 1}), do: simplify(e)
  def simplify_mul({:var, v}, {:var, v}), do: {:pow, {:num, 2}, {:var, v}}
  def simplify_mul({:num, n1}, {:num, n2}), do: {:num, n1 * n2}
  def simplify_mul(e1, e2), do: {:mul, simplify(e1), simplify(e2)} ## should I add a recursive like for add?

  # div
  #  division
  def simplify_div(e, {:num, 1}), do: e
  def simplify_div({:num, n1}, {:num, n2}), do: {:num, n1 / n2}
  def simplify_div({_, l}, {_, l}), do: {:num, 1}
  def simplify_div(e1, e2), do: {:div, e1, e2}

  # add
  def simplify_add({:num, n1}, {:num, n2}), do: {:num, n1+n2}
  def simplify_add({:var, v}, {:var, v}), do: {:mul, {:num, 2}, {:var, v}}
  def simplify_add({:num, 0}, e), do: simplify(e)
  def simplify_add(e, {:num, 0}), do: simplify(e)
  def simplify_add(e1, e2), do: {:add, e1, e2}

  # sqrt
  def simplify_sqrt({:num, n}), do: {:num, :math.sqrt(n)}
  def simplify_sqrt(e), do: {:sqrt, e}

  def pretty_print({:num, n}), do: "#{n}"
  def pretty_print({:var, v}), do: "#{v}"
#  def pretty_print({:mul, {:num, -1}, {:var, v}}), do: "-#{v}"
#  def pretty_print({:mul, {:var, v}, {:num, -1}}), do: "-#{v}"
  def pretty_print({:mul, {:num, n}, {:var, v}}), do: "#{n}#{v}"
  def pretty_print({:mul, {:var, v}, {:num, n}}), do: "#{n}#{v}"

  def pretty_print({:mul, {:num, -1}, e}), do: "-(#{pretty_print(e)})"
  def pretty_print({:mul, e, {:num, -1}}), do: "-(#{pretty_print(e)})"
  def pretty_print({:mul, {:num, n}, e}), do:  "#{n}#{pretty_print(e)}"
  def pretty_print({:mul, e, {:num, n}}), do: "#{n}#{pretty_print(e)}"

  def pretty_print({:mul, e1, e2}), do: "(#{pretty_print(e1)} * #{pretty_print(e2)})"
  def pretty_print({:pow, e1, e2}), do: "#{pretty_print(e1)}^#{pretty_print(e2)}"
  def pretty_print({:add, e1, e2}), do: "#{pretty_print(e1)} + #{pretty_print(e2)}"

  def pretty_print({:div, e1, e2}) do "(#{pretty_print(e1)} / #{pretty_print(e2)})" end

  def calculate(ast) do
    #/todo
    ast
  end


  @spec calculate(expr(), atom(), number()) :: expr()
  def calculate({:num, n}, _, _), do: {:num, n}
  def calculate({:var, v}, v, n), do: {:num, n}
  def calculate({:var, v}, _, _), do: {:num, v}
  def calculate({:add, e1, e2}, v, n), do: {:add, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:mul, e1, e2}, v, n), do: {:mul, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:exp, e1, e2}, v, n), do: {:exp, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:ln, e}, v, n), do: {:ln, calculate(e, v, n)}
  def calculate({:div, e1, e2}, v, n), do: {:div, calculate(e1, v, n), calculate(e2, v, n)}
  def calculate({:sqrt, e}, v, n), do: {:sqrt, calculate(e, v, n)}
  def calculate({:sin, e}, v, n), do: {:sin, calculate(e, v, n)}
  def calculate({:cos, e}, v, n), do: {:cos, calculate(e, v, n)}

end
