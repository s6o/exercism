defmodule BowlingHall.TerminalPlayer do
  @type t :: %__MODULE__{
          player: String.t(),
          board_state: String.t(),
          frames: list(BowlingHall.TerminalPlayerFrame.t())
        }
  @derive Jason.Encoder

  defstruct [
    :player,
    :board_state,
    :frames
  ]
end
