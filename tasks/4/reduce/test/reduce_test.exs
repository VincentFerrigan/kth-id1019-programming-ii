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
      assert Reduce.inc(test_data.list, test_data.value) == test_data.inc5
    end

    test "Decrement by given value", test_data do
      assert Reduce.dec(test_data.list, test_data.value) == test_data.dec5
    end

    test "Multiply by given value", test_data do
      assert Reduce.mul(test_data.list, test_data.value) == test_data.mul5
    end

    test "Reminder by given value", test_data do
      assert Reduce.rrem(test_data.list, test_data.value) == test_data.rem5
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
      assert Reduce.simple_length(test_data.list) == test_data.len
    end

    test "Return length of list using Tail Recursion with Accumulators", test_data do
      assert Reduce.acc_length(test_data.list) == test_data.len
    end

    test "Return sum of list using simple recursion", test_data do
      assert Reduce.simple_sum(test_data.list) == test_data.total_sum
    end

    test "Return product of list using Tail Recursion with Accumulators", test_data do
      assert Reduce.acc_sum(test_data.list) == test_data.total_sum
    end

    test "Return product of list using simple recursion", test_data do
      assert Reduce.simple_prod(test_data.list) == test_data.total_prod
    end

    test "Return sum of list using Tail Recursion with Accumulators", test_data do
      assert Reduce.acc_prod(test_data.list) == test_data.total_prod
    end

    test "Empty product", test_data do
      assert Reduce.simple_prod([]) == test_data.empty_prod
      assert Reduce.acc_prod([]) == test_data.empty_prod
    end

    test "Empty sum", test_data do
      assert Reduce.simple_sum([]) == test_data.empty_sum
      assert Reduce.acc_sum([]) == test_data.empty_sum
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
      assert Reduce.even(test_data.list) == test_data.even_list
    end

    test "Return odd numbers", test_data do
      assert Reduce.odd(test_data.list) == test_data.odd_list
    end

    test "Return all elements divisible by 3 numbers", test_data do
      assert Reduce.ddiv(test_data.list, test_data.dividor) == test_data.div_by_3_list
    end
  end
end