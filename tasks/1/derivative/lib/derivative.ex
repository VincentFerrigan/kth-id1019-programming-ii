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
  @type expr() :: {:exp, literal(), {:num, number()}}
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | literal()


  @spec derivate(expr(), atom()) :: expr()

  # The derivative of a constant is zero
  # c = 0
  def derivate({:num, _}, _), do: {:num, 0}

  # The derivative of a variable with respect to itself is 1
  def derivate({:var, v}, v), do: {:num, 1}

  # The derivative of a constant (i.e. other variable with respect to v) is zero
  def derivate({:var, _}, _), do: {:num, 0}

  # Sum Rule: f + g 	f’ + g’
  def derivate({:add, e1, e2}, v), do: {:add, derivate(e1, v), derivate(e2, v)}

  # Product Rule: (fg)’ = f g’ + f’ g
  def derivate({:mul, e1, e2}, v) do
    {:add,
      {:mul, e1, derivate(e2, v)},
      {:mul, derivate(e1, v), e2}
    }
  end

  # Power Rule: x^n = nx^(n−1)
  def derivate({:exp, {:var, v}, {:num, n}}, v) do
    {:mul,
      {:num, n},
      {:exp, {:var, v}, {:num, n-1}}
    }
  end

  # def derivate({:exp, b, {:num, n}}, v) do
  #   {:mul,
  #     {:num, n},
  #     {:exp, derivate(b, v), {:num, n-1}}
  #   }
  # end


  # Power Rule: f^n = nf^(n−1)f'
  def derivate({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul,
        {:num, n},
        {:exp, e, {:num, n-1}}},
      derivate(e, v)
    }
  end

  def simplify({:num, n}), do: ({:num, n})
  def simplify({:var, v}), do: ({:var, v})

  def simplify({:exp, _, {:num, 0}}), do: 1
  def simplify({:exp, e, {:num, 1}}), do: simplify(e)
  def simplify({:exp, e1, e2}), do: {:exp, simplify(e1), simplify(e2)}

  def simplify({:mul, {:num, 0}, _}), do: {:num, 0}
  def simplify({:mul, _, {:num, 0}}), do: {:num, 0}

  def simplify({:mul, {:var, v}, {:var, v}}), do: {:exp, {:num, 2}, {:var, v}}
  def simplify({:mul, {:num, x}, {:num, y}}), do: {:num, x*y}
  def simplify({:mul, {:num, 1}, e}), do: simplify(e)
  def simplify({:mul, e, {:num, 1}}), do: simplify(e)
  def simplify({:mul, e1, e2}), do: {:mul, simplify(e1), simplify(e2)} ## should I add a recursive like for add?

  def simplify({:add, {:num, x}, {:num, y}}), do: {:num, x+y}
  def simplify({:add, {:var, v}, {:var, v}}), do: {:mul, {:num, 2}, {:var, v}}
  def simplify({:add, {:num, 0}, e}), do: simplify(e)
  def simplify({:add, e, {:num, 0}}), do: simplify(e)
  def simplify({:add, e1, e2}), do: simplify({:add, simplify(e1), simplify(e2)}) # recursive

  # def simplify(:num, n), do: ({:num, n})

  def pretty_print({:num, n}), do: "#{n}"
  def pretty_print({:var, v}), do: "#{v}"

  def pretty_print({:add, e1, e2}) do
    "#{pretty_print(e1)} + #{pretty_print(e2)}"
  end

  def pretty_print({:mul, {:num, n}, {:var, v}}), do: "#{n}#{v}"
  def pretty_print({:mul, {:var, v}}, {:num, n}), do: "#{n}#{v}"
  def pretty_print({:mul, e1, e2}) do
    "(#{pretty_print(e1)} * #{pretty_print(e2)})"
  end

  def pretty_print({:exp, e1, e2}) do
    "#{pretty_print(e1)}^#{pretty_print(e2)}"
  end

end
