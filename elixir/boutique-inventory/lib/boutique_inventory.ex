defmodule BoutiqueInventory do
  @type sizes() ::
          %{}
          | %{
              :s => non_neg_integer(),
              :m => non_neg_integer(),
              :l => non_neg_integer(),
              :xl => non_neg_integer()
            }
  @type item() :: %{
          :name => binary(),
          :price => nil | pos_integer(),
          :quantity_by_size => sizes()
        }

  @spec sort_by_price(list(item)) :: list(item)
  def sort_by_price(inventory) do
    Enum.sort_by(inventory, & &1.price, &<=/2)
  end

  @spec with_missing_price(list(item)) :: list(item)
  def with_missing_price(inventory) do
    Enum.filter(inventory, fn item -> is_nil(item.price) end)
  end

  @spec update_names(list(item), bitstring(), bitstring()) :: list(item)
  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item ->
      %{item | :name => String.replace(item.name, old_word, new_word)}
    end)
  end

  @spec increase_quantity(item(), pos_integer()) :: item()
  def increase_quantity(item, count) do
    %{
      item
      | :quantity_by_size => Map.new(item.quantity_by_size, fn {k, c} -> {k, c + count} end)
    }
  end

  @spec total_quantity(item()) :: non_neg_integer()
  def total_quantity(item) do
    Enum.reduce(item.quantity_by_size, 0, fn {_k, c}, acc -> acc + c end)
  end
end
