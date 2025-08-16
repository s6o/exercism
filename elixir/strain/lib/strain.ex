defmodule Strain do
  @moduledoc false

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    for x <- list, do: fun.(x)
    # Enum.reduce(list, [], fn e, acc -> if(fun.(e), do: acc ++ [e], else: acc) end)
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    for x <- list, do: not fun.(x)
    # Enum.reduce(list, [], fn e, acc -> if(fun.(e), do: acc, else: acc ++ [e]) end)
  end
end
