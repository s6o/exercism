defmodule IslandsEngine.Island do
  @moduledoc """
  Possible island types:

  xx square   xx atoll   x dot   x. l-shape   .xx s-shape
  xx          .x                 x.           xx.
              xx                 xx
  """
  @type t :: %__MODULE__{
          :coordinates => MapSet.t(IslandsEngine.Coordinate.t()),
          :hit_coordinates => MapSet.t(IslandsEngine.Coordinate.t()),
          :shape => island_shape()
        }
  @type island_shape() :: :atoll | :dot | :l_shape | :s_shape | :square
  @enforce_keys [:coordinates, :hit_coordinates, :shape]
  defstruct [:coordinates, :hit_coordinates, :shape]

  alias IslandsEngine.Coordinate
  alias IslandsEngine.Guesses

  @spec new(shape :: island_shape(), top_left :: IslandsEngine.Coordinate.t()) ::
          {:ok, t()}
          | {:error, :unknown_island}
          | {:error, {:invalid_coordinate, {integer(), integer()}}}
  def new(shape, %Coordinate{} = top_left) do
    case offsets(shape) do
      [] ->
        {:error, :unknown_island}

      [_ | _] = offsets ->
        with %MapSet{} = coordinates <- add_coordinates(offsets, top_left) do
          {:ok,
           %__MODULE__{coordinates: coordinates, hit_coordinates: MapSet.new(), shape: shape}}
        end
    end
  end

  @spec guess(island :: t(), guess_coordinate :: Coordinate.t()) :: {Guesses.guess_result(), t()}
  def guess(%__MODULE__{coordinates: coordinates} = island, %Coordinate{} = guess_coordinate) do
    case MapSet.member?(coordinates, guess_coordinate) do
      false ->
        {:miss, island}

      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, guess_coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}
    end
  end

  @spec forested?(island :: t()) :: boolean()
  def forested?(%__MODULE__{coordinates: coordinates, hit_coordinates: hits}) do
    MapSet.equal?(coordinates, hits)
  end

  @spec overlaps?(t(), t()) :: boolean()
  def overlaps?(%__MODULE__{coordinates: ac}, %__MODULE__{coordinates: bc}) do
    not MapSet.disjoint?(ac, bc)
  end

  @spec shapes() :: list(island_shape())
  def shapes(), do: [:atoll, :dot, :l_shape, :s_shape, :square]

  defp add_coordinates(offsets, top_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, top_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: r, col: c}, {ro, co}) do
    case Coordinate.new(r + ro, c + co) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}

      {:error, _} = e ->
        {:halt, e}
    end
  end

  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(_), do: []
end
