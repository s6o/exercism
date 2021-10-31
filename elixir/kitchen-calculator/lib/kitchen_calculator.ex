defmodule KitchenCalculator do
  @spec get_volume({atom(), number()}) :: number() | :error
  def get_volume(volume_pair) do
    case volume_pair do
      {_, volume} -> volume
      _ -> :error
    end
  end

  @spec to_milliliter({atom, number}) :: {:error, :unknown_unit} | {:milliliter, number}
  def to_milliliter(volume_pair) do
    with {:ok, %KitchenUnit{} = u} <- KitchenUnit.to_milliliter(volume_pair) do
      {u.name, u.volume}
    end
  end

  @spec from_milliliter({atom(), number()}, atom()) ::
          {:error, :unknown_unit} | {atom(), number()}
  def from_milliliter(volume_pair, unit) do
    with {:ok, %KitchenUnit{} = u} <- KitchenUnit.from_milliliter(volume_pair, unit) do
      {u.name, u.volume}
    end
  end

  @spec convert({atom(), number()}, atom()) ::
          {:error, :unknown_unit} | {atom(), number()}
  def convert(volume_pair, unit) do
    with {:ok, %KitchenUnit{} = u} <- KitchenUnit.from_unit_to(volume_pair, unit) do
      {u.name, u.volume}
    end
  end
end
