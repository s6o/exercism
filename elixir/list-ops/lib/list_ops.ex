defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.
  @type acc :: any()

  @spec append(list, list) :: list
  def append(a, b), do: reduce(b, reverse(a), fn i, a -> [i | a] end) |> reverse()

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    reduce(ll, [], fn l, a -> reduce(l, a, fn i, a -> [i | a] end) end) |> reverse()
  end

  @spec count(list) :: non_neg_integer
  def count(l), do: reduce(l, 0, fn _, c -> c + 1 end)

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    reduce(l, [], fn i, a -> if(f.(i), do: [i | a], else: a) end) |> reverse()
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    reduce(l, [], fn i, a -> [f.(i) | a] end) |> reverse()
  end

  @spec foldl(list, any, (any, any -> any)) :: any
  def foldl(l, acc, f), do: reduce(l, acc, f)

  @spec foldr(list, any, (any, any -> any)) :: any
  def foldr(l, acc, f), do: reverse(l) |> reduce(acc, f)

  @spec reverse(list) :: list
  def reverse(l), do: reduce(l, [], fn i, a -> [i | a] end)

  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  defp reduce(l, acc, f) do
    case l do
      [] -> acc
      [h | rest] -> reduce(rest, f.(h, acc), f)
    end
  end
end
