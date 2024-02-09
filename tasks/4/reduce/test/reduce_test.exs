defmodule ReduceTest do
  use ExUnit.Case
  doctest Reduce

  describe "Testing Map Functions" do
    test "Increment by given value", do:
      assert Reduce.map_inc([1,2,3,4,5], 5) == [1+5,2+5,3+5,4+5,5+5]

    test "Decrement by given value", do:
      assert Reduce.map_dec([1,2,3,4,5], 5) == [1-5,2-5,3-5,4-5,5-5]

    test "Multiply by given value", do:
      assert Reduce.map_mul([1,2,3,4,5], 5) == [1*5,2*5,3*5,4*5,5*5]

    test "Reminder by given value", do:
      assert Reduce.map_rem([1,2,3,4,5], 5) == [1,2,3,4,0]
  end

  describe "Testing Reduce Functions" do
    test "Return length non-empty of list", do:
      assert Reduce.simple_reduce_length([1,2,3,4]) == 4
      assert Reduce.acc_reduce_length([1,2,3,4])    == 4

    test "Return sum of non-empty list", do:
      assert Reduce.simple_reduce_sum([1,2,3,4])    == 1+2+3+4
      assert Reduce.acc_reduce_sum([1,2,3,4])       == 1+2+3+4

    test "Return product of non-empty list", do:
      assert Reduce.simple_reduce_prod([1,2,3,4])   == 1*2*3*4
      assert Reduce.acc_reduce_prod([1,2,3,4])      == 1*2*3*4

    test "Empty sum", do:
      assert Reduce.simple_reduce_sum([])           == 0
      assert Reduce.acc_reduce_sum([])              == 0

    test "Empty product", do:
      assert Reduce.simple_reduce_prod([])          == 1
      assert Reduce.acc_reduce_prod([])             == 1
  end

  describe "Testing filter Functions" do
    test "Return even numbers", do:
      assert Reduce.filter_even([0,1,2,3,4,5,6]) == [0,2,4,6]

    test "Return odd numbers", do:
      assert Reduce.filter_odd([0,1,2,3,4,5,6]) == [1,3,5]

    test "Return all elements divisible by 3 numbers", do:
      assert Reduce.filter_div([0,1,2,3,4,5,6], 3) == [0,3,6]
  end

  describe "Testing the higher order functions" do
    test "Increment by given value", do:
      assert Reduce.map([1,2,3,4,5], &(&1+5)) == [1+5,2+5,3+5,4+5,5+5]

    test "Decrement by given value", do:
      assert Reduce.map([1,2,3,4,5], &(&1-5)) == [1-5,2-5,3-5,4-5,5-5]

    test "Multiply by given value", do:
      assert Reduce.map([1,2,3,4,5], &(&1*5)) == [1*5,2*5,3*5,4*5,5*5]

    test "Reminder by given value", do:
      assert Reduce.map([1,2,3,4,5], &rem(&1,5)) == [1,2,3,4,0]

    test "Return length non-empty of list", do:
      assert Reduce.reduce([1,2,3,4], 0, fn _elem, acc -> 1+acc end) == 4

    test "Return sum of non-empty list", do:
      assert Reduce.reduce([1,2,3,4],0, &(+/2))  == 1+2+3+4

    test "Return product of non-empty list", do:
      assert Reduce.reduce([1,2,3,4], 1, &(*/2))  == 1*2*3*4

    test "Empty sum", do:
      assert Reduce.reduce([], 0, &(+/2)) == 0

    test "Empty product", do:
      assert Reduce.reduce([], 1, &(*/2))  == 1

    test "Return even numbers", do:
      assert Reduce.filter([0,1,2,3,4,5,6], &rem(&1, 2) == 0) == [0,2,4,6]

    test "Return odd numbers", do:
      assert Reduce.filter([0,1,2,3,4,5,6], &rem(&1, 2) != 0) == [1,3,5]

    test "Return all elements divisible by 3 numbers", do:
      assert Reduce.filter([0,1,2,3,4,5,6], &rem(&1, 3) == 0) == [0,3,6]
  end

  describe "Test piping, take a list of integers
            and returns the sum of the square of all values less than n" do
    test "Piping step by step" do
      n = 8
      list = [1,2,3,4,5,6,7,8,9]
      exp_result = 1*1+2*2+3*3+4*4+5*5+6*6+7*7
      test_result = list |> Reduce.filter(&(&1 < n))
                         |> Reduce.map(&(&1*&1))
                         |> Reduce.reduce(0, &(+/2))

      assert test_result == exp_result
    end

    test "Test the func that pipes" do
      n = 8
      list = [1,2,3,4,5,6,7,8,9]
      exp_result = 1*1 + 2*2 + 3*3+ 4*4 + 5*5 + 6*6 + 7*7
      test_result = Reduce.sum_of_squares_below(list, n)

      assert test_result == exp_result
    end
  end
end