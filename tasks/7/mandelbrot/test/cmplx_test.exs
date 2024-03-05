defmodule CmplxTest do
  use ExUnit.Case
  doctest Cmplx

  test "Create complex number 1+2i", do:
    assert Cmplx.new(1, 2) == {:cpx, 1, 2}
  test "Square a complex number", do:
    assert Cmplx.sqr({:cpx, 1, 2}) == {:cpx, -3, 4}
  test "The sum of 5 + 3i and 4 + 2i is 9 + 5i.", do:
    assert Cmplx.add({:cpx, 5, 3}, {:cpx, 4, 2}) == {:cpx, 9, 5}
  test "The absolut value of (-2 +3i) is sqr(13)", do:
    assert Cmplx.abs({:cpx, -2, 3}) == :math.sqrt(13)
end
