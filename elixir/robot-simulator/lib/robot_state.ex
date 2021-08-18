defmodule RobotState do
  @type t :: %__MODULE__{
          direction: :east | :north | :south | :west,
          position: {integer(), integer()}
        }
  defstruct [
    :direction,
    :position
  ]

  @spec create(direction :: :east | :north | :south | :west, position :: {integer, integer}) ::
          {:ok, RobotState.t()} | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, {x, y}) when is_integer(x) and is_integer(y) do
    if Enum.member?(directions(), direction) do
      {:ok, %RobotState{:direction => direction, :position => {x, y}}}
    else
      {:error, "invalid direction"}
    end
  end

  def create(_d, _p), do: {:error, "invalid position"}

  @spec turn_left(state :: RobotState.t()) :: RobotState.t()
  def turn_left(%RobotState{:direction => d} = state) do
    case d do
      :east -> %RobotState{state | :direction => :north}
      :north -> %RobotState{state | :direction => :west}
      :south -> %RobotState{state | :direction => :east}
      :west -> %RobotState{state | :direction => :south}
    end
  end

  @spec turn_right(state :: RobotState.t()) :: RobotState.t()
  def turn_right(%RobotState{:direction => d} = state) do
    case d do
      :east -> %RobotState{state | :direction => :south}
      :north -> %RobotState{state | :direction => :east}
      :south -> %RobotState{state | :direction => :west}
      :west -> %RobotState{state | :direction => :north}
    end
  end

  @spec update_position(state :: RobotState.t()) :: RobotState.t()
  def update_position(%RobotState{:direction => d, :position => {x, y}} = state) do
    case d do
      :east -> %RobotState{state | :position => {x + 1, y}}
      :north -> %RobotState{state | :position => {x, y + 1}}
      :south -> %RobotState{state | :position => {x, y - 1}}
      :west -> %RobotState{state | :position => {x - 1, y}}
    end
  end

  defp directions(), do: [:east, :north, :south, :west]
end
