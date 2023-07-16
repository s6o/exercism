defmodule Day5 do
  _ = "Understanding ETS match specs"

  def make_table() do
    table = :ets.new(:some_table, [])
    :ets.insert(table, {:foo, 1})
    :ets.insert(table, {:bar, 2})
    :ets.insert(table, {:baz, 0})
    table
  end

  def items_as_list(table) do
    :ets.select(table, [{:"$1", [], [:"$1"]}])
  end

  def item_keys(table) do
    :ets.select(table, [{{:"$1", :_}, [], [:"$1"]}])
  end

  def value_key_tuples(table) do
    :ets.select(table, [{{:"$1", :"$2"}, [], [{{:"$2", :"$1"}}]}])
  end

  def items_as_map(table) do
    :ets.select(table, [{{:"$1", :"$2"}, [], [%{value: :"$2", key: :"$1"}]}])
  end

  @doc """
  Filter section (triplet tuple) for non numeric values needs {:const, v} e.g.
  [{:>, "$2", {:const, v}}]
  """
  def filter_gt_zero(table) do
    :ets.select(table, [{{:_, :"$2"}, [{:>, :"$2", 0}], [:"$2"]}])
  end

  def filter_gt_zero_lt_two_keys(table) do
    :ets.select(table, [{{:"$1", :"$2"}, [{:>, :"$2", 0},{:<, :"$2", 2}], [:"$1"]}])
  end

  def create_gt_two_matchspec() do
    # Fails here, but works in IEX ?!
    ms = :ets.fun2ms(fn {_, x} when x > 2 -> x end)
    ms
  end
end
