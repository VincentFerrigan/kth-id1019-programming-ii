defmodule DerivativeTest do
  use ExUnit.Case
  doctest Derivative

  test "greets the world" do
    assert Derivative.hello() == :world
  end

  test "Derivate constant value with respect to x, '7'" do
    e = {:num, 7}
    assert Derivative.derivate(e, :x)
      == {:num, 0}
  end

  test "Derivate constant value with respect to x, 'pi'" do
    e = {:var, :math.pi()}
    assert Derivative.derivate(e, :x)
      == {:num, 0}
  end

  test "Derivate x with respect to x, 'x'" do
    e = {:var, :x}
    assert Derivative.derivate(e, :x)
      == {:num, 1}
  end


  test "Derivate ax with respect to x, '2x'" do
    e = {:mul, {:num, 2}, {:var, :x}}
    assert Derivative.derivate(e, :x)
      == {:add,
           {:mul, {:num, 2}, {:num, 1}},
           {:mul, {:num, 0}, {:var, :x}}
          }
  end

  test "Derivative 2x + 4" do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    assert Derivative.derivate(e, :x)
      == {:add,
           {:add,
             {:mul, {:num, 2}, {:num, 1}},
             {:mul, {:num, 0}, {:var, :x}}
            },
           {:num, 0}
          }
  end

  test "Derivative x^2" do
    e = {:exp, {:var, :x}, {:num, 2}}
    assert Derivative.derivate(e, :x)
      == {:mul,
           {:num, 2},
           {:exp, {:var, :x}, {:num, 1}}
          }
  end

  test "Simplify 3 + 2" do
    e = {:add, {:num, 3}, {:num, 2}}
    assert Derivative.simplify(e)
      == {:num, 5}
  end

  test "Simplify 3 * 2" do
    e = {:mul, {:num, 3}, {:num, 2}}
    assert Derivative.simplify(e)
      == {:num, 6}
  end

  test "Simplify x * 0" do
    e = {:mul, {:var, :x}, {:num, 0}}
    assert Derivative.simplify(e)
      == {:num, 0}
  end

  test "pprint 3" do
    e = {:num, 3}
    assert Derivative.pretty_print(e)
      == "3"
  end

  test "simplify to 2" do
      e = {:add,
            {:add,
              {:mul, {:num, 2}, {:num, 1}},
              {:mul, {:num, 0}, {:var, :x}}
            },
            {:num, 0}
          }
      assert Derivative.simplify(e)
        == {:num, 2}
  end

  test "simplify to 2 + 0" do
    e = {:add, {:num, 2}, {:num, 0}}
    assert Derivative.simplify(e) == {:num, 2}
  end

  test "simplify to 2 * x" do
    e = {:mul, {:num, 2}, {:var, :x}}
    assert Derivative.simplify(e) == e
  end

  test "derivate, simply and pprint 2x + 4" do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    d = Derivative.derivate(e, :x)
    s = Derivative.simplify(d)
    p = Derivative.pretty_print(s)
    assert p == "2"
  end

  test "Simpify to 2x" do
    e = {:mul,
           {:num, 2},
           {:exp, {:var, :x}, {:num, 1}}
          }
    assert Derivative.simplify(e)
      == {:mul, {:num, 2}, {:var, :x}}
  end

  test "Derivate, simplify and pprint x^2" do
    e = {:exp, {:var, :x}, {:num, 2}}
    d = Derivative.derivate(e, :x)
    s = Derivative.simplify(d)
    p = Derivative.pretty_print(s)
    assert p == "2x"
  end

end
