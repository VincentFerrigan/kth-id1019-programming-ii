defmodule ReduceTest do
  use ExUnit.Case
  doctest Reduce

  # MAP
  describe "Testing Map Functions" do
    setup do
      [
        list: [1,2,3,4,5],
        value: 5,
        inc5: [1+5, 2+5, 3+5, 4+5, 5+5],
        dec5: [1-5, 2-5, 3-5, 4-5, 5-5],
        mul5: [1*5, 2*5, 3*5, 4*5, 5*5],
        rem5: [1, 2, 3, 4, 0],
      ]
    end

    test "Increment by given value", test_data do
      assert Reduce.map_inc(test_data.list, test_data.value) == test_data.inc5
      assert Reduce.map(test_data.list, fn x -> x + test_data.value end) == test_data.inc5
    end

    test "Decrement by given value", test_data do
      assert Reduce.map_dec(test_data.list, test_data.value) == test_data.dec5
      assert Reduce.map(test_data.list, fn x -> x - test_data.value end) == test_data.dec5
    end

    test "Multiply by given value", test_data do
      assert Reduce.map_mul(test_data.list, test_data.value) == test_data.mul5
      assert Reduce.map(test_data.list, fn x -> x * test_data.value end) == test_data.mul5
    end

    test "Reminder by given value", test_data do
      assert Reduce.map_rem(test_data.list, test_data.value) == test_data.rem5
      assert Reduce.map(test_data.list, &rem(&1,test_data.value))
    end

  end

  # REDUCE
  describe "Testing Reduce Functions" do
    setup do
      [
        list: [1,2,3,4],
        len: 4,
        total_sum: 10,
        total_prod: 1*2*3*4,
        empty_prod: 1,
        empty_sum: 0,
      ]
    end

    test "Return length of list using simple recursion", test_data do
      assert Reduce.simple_reduce_length(test_data.list) == test_data.len
    end

    test "Return length of list using Tail Recursion with Accumulators", test_data do
      assert Reduce.acc_reduce_length(test_data.list) == test_data.len
      assert Reduce.reduce(test_data.list, 0, fn _elem, acc -> acc + 1 end) == test_data.len
    end

    test "Return sum of list using simple recursion", test_data do
      assert Reduce.simple_reduce_sum(test_data.list) == test_data.total_sum
    end

    test "Return sum of list using Tail Recursion with Accumulators", test_data do
      assert Reduce.acc_reduce_prod(test_data.list) == test_data.total_prod
      assert Reduce.reduce(test_data.list, 0, fn (x, acc) -> x + acc end) == test_data.total_sum
    end

    test "Return product of list using simple recursion", test_data do
      assert Reduce.simple_reduce_prod(test_data.list) == test_data.total_prod
    end

    test "Return product of list using Tail Recursion with Accumulators", test_data do
      assert Reduce.acc_reduce_sum(test_data.list) == test_data.total_sum
      assert Reduce.reduce(test_data.list, 1, fn (x, acc) -> x * acc end) == test_data.total_prod
    end

    test "Empty sum", test_data do
      assert Reduce.simple_reduce_sum([]) == test_data.empty_sum
      assert Reduce.acc_reduce_sum([]) == test_data.empty_sum
      assert Reduce.reduce([], 0, fn (x, acc) -> x + acc end) == test_data.empty_sum
    end

    test "Empty product", test_data do
      assert Reduce.simple_reduce_prod([]) == test_data.empty_prod
      assert Reduce.acc_reduce_prod([]) == test_data.empty_prod
      assert Reduce.reduce([], 1, fn (x, acc) -> x * acc end) == test_data.empty_prod
    end

  end

  # FILTER
  describe "Testing filter Functions" do
    setup do
      [
        list: [0,1,2,3,4,5,6],
        dividor: 3,
        even_list: [0,2,4,6],
        odd_list: [1,3,5],
        div_by_3_list: [0,3,6],
      ]
    end

    test "Return even numbers", test_data do
      assert Reduce.filter_even(test_data.list) == test_data.even_list
      assert Reduce.filter(test_data.list, fn x -> rem(x, 2) == 0 end) == test_data.even_list
    end

    test "Return odd numbers", test_data do
      assert Reduce.filter_odd(test_data.list) == test_data.odd_list
      assert Reduce.filter(test_data.list, fn x -> rem(x, 2) != 0 end) == test_data.odd_list
    end

    test "Return all elements divisible by 3 numbers", test_data do
      assert Reduce.filter_div(test_data.list, 3) == test_data.div_by_3_list
      assert Reduce.filter(test_data.list, fn x -> rem(x, 3) == 0 end) == test_data.div_by_3_list
    end
  end


end