defmodule CmplxTest do
  use ExUnit.Case
  doctest Cmplx

  test "Create complex number 1+2i", do:
    assert Cmplx.new(1, 2) == {:cpx, 1, 2}
  test "Square a complex number", do:
    assert Cmplx.sqr({:cpx, 1, 2}) == {:cpx, -3, 4}
end