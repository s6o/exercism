defmodule RobotInstruction do
  @type t :: %__MODULE__{
          instruction: String.t()
        }
  defstruct [
    :instruction
  ]

  @spec create(instruction :: String.t()) :: {:ok, RobotInstruction.t()} | {:error, String.t()}
  def create(instruction) do
    if Enum.member?(instructions(), instruction) do
      {:ok, %RobotInstruction{:instruction => instruction}}
    else
      {:error, "invalid instruction"}
    end
  end

  @spec execute(
          instruction :: {:ok, RobotInstruction.t()} | {:error, String.t()},
          state :: {:ok, RobotState.t()} | {:error, String.t()}
        ) :: {:ok, RobotState.t()} | {:error, RobotState.t()}
  def execute(
        {:ok, %RobotInstruction{:instruction => i}},
        {:ok, %RobotState{} = state}
      ) do
    {:ok,
     case i do
       "A" -> RobotState.update_position(state)
       "L" -> RobotState.turn_left(state)
       "R" -> RobotState.turn_right(state)
     end}
  end

  def execute({:error, _} = ri, _), do: ri
  def execute(_, {:error, _} = rs), do: rs

  defp instructions(), do: ["A", "L", "R"]
end
