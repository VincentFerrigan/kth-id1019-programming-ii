defmodule ExpressionTest do
  use ExUnit.Case
  doctest Expression

  test "Evaluate 7" do
    e = {:num, 7}
    env = Map.new()
    env = Map.put(env, :x, 5)
    assert Expression.eval(e, env) == {:num, 7}
  end

  test "Evaluate x, where x = 5" do
    e = {:var, :x}
    env = Map.new()
    env = Map.put(env, :x, 5)
    assert Expression.eval(e, env) == {:num, 5}
  end

  test "Evaluate 3x/2x, where x = 2" do
    e = {:div, {:mul, {:num, 3}, {:var, :x}}, {:mul, {:num, 2}, {:var, :x}}}
    env = Map.new()
    env = Map.put(env, :x, 2)
    assert Expression.eval(e, env) == {:q, 3, 2}
  end

  test "Evaluate 2x + 3 + 1/2, where x = 2" do
    e = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1, 2}}
    env = Map.new()
    env = Map.put(env, :x, 2)
    assert Expression.eval(e, env) == {:q, 15, 2}
  end
end
