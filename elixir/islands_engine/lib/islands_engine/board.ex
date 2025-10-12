defmodule IslandsEngine.Board do
  @type t :: map()

  alias IslandsEngine.Coordinate
  alias IslandsEngine.Island
  alias IslandsEngine.Guesses

  @spec new() :: t()
  def new(), do: %{}

  @spec position_island(board :: t(), island :: Island.t()) ::
          {:ok, t()} | {:error, :overlapping_island}
  def position_island(board, %Island{shape: key} = island) when is_map(board) do
    case overlaps_existing_island?(board, island) do
      false -> {:ok, Map.put(board, key, island)}
      true -> {:error, :overlapping_island}
    end
  end

  @spec all_islands_positioned?(board :: t()) :: boolean()
  def all_islands_positioned?(board) when is_map(board) do
    Enum.all?(Island.shapes(), &Map.has_key?(board, &1))
  end

  @spec guess(board :: t(), guess_coordinate :: Coordinate.t()) ::
          {Guesses.guess_result(), :none | Island.island_shape(), :no_win | :win, t()}
  def guess(board, %Coordinate{} = guess_coordinate) when is_map(board) do
    board
    |> check_all_islands(guess_coordinate)
    |> guess_response(board)
  end

  defp check_all_islands(board, coordinate) when is_map(board) do
    Enum.reduce_while(board, {:miss, nil}, fn {_key, island}, _ ->
      case Island.guess(island, coordinate) do
        {:miss, _} = r -> {:cont, r}
        {:hit, _} = r -> {:halt, r}
      end
    end)
  end

  defp guess_response({guess_result, %Island{shape: key} = island}, board) when is_map(board) do
    case guess_result do
      :hit ->
        new_board = %{board | key => island}
        {:hit, forest_check(new_board, key), win_check(new_board), new_board}

      :miss ->
        {:miss, :none, :no_win, board}
    end
  end

  defp forest_check(board, key) do
    case forested?(board, key) do
      false -> :none
      true -> key
    end
  end

  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    case all_forested?(board) do
      false -> :no_win
      true -> :win
    end
  end

  defp all_forested?(board) do
    Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)
  end

  defp overlaps_existing_island?(board, %Island{shape: new_key} = new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end
end
