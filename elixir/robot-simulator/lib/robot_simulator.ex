defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: nil | atom(), position :: nil | {integer, integer}) :: any
  def create(direction \\ nil, position \\ nil)

  def create(nil, nil), do: RobotState.create()

  def create(direction, {x, y} = position)
      when is_atom(direction) and is_integer(x) and is_integer(y) do
    RobotState.create(direction, position)
  end

  def create(direction, _position) when is_atom(direction), do: {:error, "invalid position"}
  def create(_direction, _position), do: {:error, "invalid direction"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    if Kernel.is_bitstring(instructions) do
      case robot do
        {:ok, %RobotState{}} = rs ->
          instructions
          |> String.split(~r{\w}, include_captures: true, trim: true)
          |> Enum.reduce_while(rs, fn instruction, accum ->
            ri = RobotInstruction.create(instruction)
            next_rs = RobotInstruction.execute(ri, accum)

            case next_rs do
              {:ok, _} = nrs -> {:cont, nrs}
              error -> {:halt, error}
            end
          end)

        error ->
          error
      end
    else
      {:error, "invalid instruction"}
    end
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    case robot do
      {:ok, %RobotState{:direction => d}} -> d
      _ -> {:error, "invalid direction"}
    end
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    case robot do
      {:ok, %RobotState{:position => p}} -> p
      _ -> {:error, "invalid position"}
    end
  end
end
