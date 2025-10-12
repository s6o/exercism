defmodule IslandsEngine.Guesses do
  @type t :: %__MODULE__{
          :hits => MapSet.t(),
          :misses => MapSet.t()
        }
  @type guess_result() :: :hit | :miss

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  alias IslandsEngine.Coordinate

  @spec new() :: t()
  def new(), do: %__MODULE__{hits: MapSet.new(), misses: MapSet.new()}

  @spec add(guesses :: t(), guess :: guess_result(), coordinate :: Coordinate.t()) :: t()
  def add(%__MODULE__{} = guesses, :hit, %Coordinate{} = coordinate),
    do: update_in(guesses.hits, &MapSet.put(&1, coordinate))

  def add(%__MODULE__{} = guesses, :miss, %Coordinate{} = coordinate),
    do: update_in(guesses.misses, &MapSet.put(&1, coordinate))
end
