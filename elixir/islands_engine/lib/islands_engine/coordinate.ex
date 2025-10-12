defmodule IslandsEngine.Coordinate do
  @type t :: %__MODULE__{
          :row => non_neg_integer(),
          :col => non_neg_integer()
        }
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @col_range 1..10
  @row_range 1..10

  def new(row, col) when row in @row_range and col in @col_range,
    do: {:ok, %__MODULE__{row: row, col: col}}

  def new(row, col), do: {:error, {:invalid_coorinate, {row, col}}}
end
