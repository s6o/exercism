defmodule KitchenUnit do
  @type t :: %__MODULE__{
          name: :cup | :fluid_ounce | :teaspoon | :tablespoon | :milliliter,
          volume: number()
        }
  defstruct [
    :name,
    :volume
  ]

  @units %{
    :cup => 240,
    :fluid_ounce => 30,
    :teaspoon => 5,
    :tablespoon => 15,
    :milliliter => 1
  }

  @spec to_milliliter({atom(), number()}) ::
          {:ok, KitchenUnit.t()} | {:error, :unknown_unit}
  def to_milliliter({unit, v}) do
    if Enum.member?(Map.keys(@units), unit) do
      {:ok, %KitchenUnit{name: :milliliter, volume: @units[unit] * v}}
    else
      {:error, :unknown_unit}
    end
  end

  def to_milliliter(_), do: {:error, :unknown_unit}

  @spec from_milliliter({:milliliter, number()} | {:error, :unknown_unit}, atom()) ::
          {:ok, KitchenUnit.t()} | {:error, :unknown_unit}
  def from_milliliter({:ok, %KitchenUnit{name: :milliliter, volume: v}}, unit),
    do: from_milliliter({:milliliter, v}, unit)

  def from_milliliter({:milliliter, v}, unit) do
    if Enum.member?(Map.keys(@units), unit) do
      {:ok, %KitchenUnit{name: unit, volume: v / @units[unit]}}
    else
      {:error, :unknown_unit}
    end
  end

  def from_milliliter(_, _), do: {:error, :unknown_unit}

  @spec from_unit_to({atom(), number()}, atom()) ::
          {:ok, KitchenUnit.t()} | {:error, :unknown_unit}
  def from_unit_to(volume_pair, to_unit) do
    KitchenUnit.to_milliliter(volume_pair)
    |> KitchenUnit.from_milliliter(to_unit)
  end
end
