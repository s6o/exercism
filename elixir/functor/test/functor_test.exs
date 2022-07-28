defmodule FunctorTest do
  use ExUnit.Case

  test "Functor for List" do
    assert [2, 4, 6] == Functor.fmap([1, 3, 5], fn x -> x + 1 end)
  end

  test "Functor for Map" do
    result = Functor.fmap(%{Netherlands: "Amsterdam"}, fn {k, v} -> {k, v <> "!"} end)
    assert Map.equal?(%{Netherlands: "Amsterdam!"}, result)
  end

  test "Functor for Tree" do
    initial = %Tree{
      value: 1,
      children: [%Tree{value: 2, children: []}, %Tree{value: 3, children: []}]
    }

    actual = Functor.fmap(initial, fn x -> x + 1 end)

    expected = %Tree{
      children: [%Tree{children: [], value: 3}, %Tree{children: [], value: 4}],
      value: 2
    }

    assert expected == actual
    assert Map.equal?(Map.from_struct(expected), Map.from_struct(actual))
  end

  test "Functor for Tuple {:ok, a}" do
    assert {:ok, 2} == Functor.fmap({:ok, 1}, fn x -> x + 1 end)
  end

  test "Functor for Tuple {:error, a}" do
    assert {:error, "still error"} == Functor.fmap({:error, "still error"}, fn x -> x <> "!" end)
  end

  test "Functor for Tuple {1}, {1, 3} or {1, 3, 5}" do
    assert {2} == Functor.fmap({1}, fn x -> x + 1 end)
    assert {2, 4} == Functor.fmap({1, 3}, fn x -> x + 1 end)
    assert {2, 4, 6} == Functor.fmap({1, 3, 5}, fn x -> x + 1 end)
  end
end
