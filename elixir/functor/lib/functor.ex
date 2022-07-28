defprotocol Functor do
  def fmap(fa, f)
end

defimpl Functor, for: List do
  @spec fmap(fa :: list(), f :: (a :: any() -> b :: any())) :: list()
  def fmap(fa, f), do: :lists.map(f, fa)
end

defimpl Functor, for: Map do
  @spec fmap(fa :: map(), f :: ({ka :: any(), va :: any()} -> {kb :: any(), vb :: any()})) ::
          map()
  def fmap(fa, f) do
    kvs = Map.to_list(fa)
    :lists.map(fn kv -> f.(kv) end, kvs) |> Enum.into(%{})
  end
end

defimpl Functor, for: Tuple do
  @spec fmap(fa :: tuple(), f :: (a :: any() -> b :: any())) :: tuple()

  def fmap({:ok, a}, f), do: {:ok, f.(a)}
  def fmap({:error, a}, _f), do: {:error, a}

  def fmap(t, f) when is_tuple(t) do
    last_index = tuple_size(t) - 1

    0..last_index
    |> Enum.reduce({}, fn index, fb -> Tuple.append(fb, f.(elem(t, index))) end)
  end
end
