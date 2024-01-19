defmodule Derivative do
  @moduledoc """
  Documentation for `Derivative`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Derivative.hello()
      :world

  """
  def hello do
    :world
  end

  @type literal() ::  {:num, number()}  | {:var, atom()}
  @type expr() :: {:add, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:pow, expr(), literal()}
    | {:ln, expr()}
    | {:div, expr(), expr()}
    | {:sin, expr()}
    | {:cos, expr()}
    | {:sqrt, expr()}
    | literal()

  @spec run(expr(), atom(), number()) :: ??
  def run(ast, variable, value) do
    derivative_of_function = find_derivative(ast, variable)
    simplification =  simplify(derivative_of_function)
    result = calculate(simplification)

    IO.write("The derivative of function #{pretty_print(ast)} at given value of x = #{value}:\n\n")
    IO.write("Derivative: #{pretty_print(derivative_of_function)}\n")
    IO.write("Simplified: #{pretty-print(simplification)}\n")
    IO.write("Calculated: #{pretty_print(result)}\n")
  end

  @spec find_derivative(expr(), atom()) :: expr()

  # The derivative of a constant is zero
  # c = 0
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
  def pretty_print({:mul, {:num, n}, e}), do:  "#{n}#{pretty_print(e)})"
  def pretty_print({:mul, e, {:num, n}}), do: "#{n}#{pretty_print(e)})"

  def pretty_print({:mul, e1, e2}), do: "(#{pretty_print(e1)} * #{pretty_print(e2)})"
  def pretty_print({:pow, e1, e2}), do: "#{pretty_print(e1)}^#{pretty_print(e2)}"
  def pretty_print({:add, e1, e2}), do: "#{pretty_print(e1)} + #{pretty_print(e2)}"

  def pretty_print({:div, e1, e2}) do "(#{pretty_print(e1)} / #{pretty_print(e2)})" end

end
