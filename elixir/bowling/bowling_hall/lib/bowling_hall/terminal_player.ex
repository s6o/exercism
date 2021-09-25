defmodule BowlingHall.TerminalPlayer do
  @type t :: %__MODULE__{
          player: String.t(),
          frames: list(BowlingHall.TerminalPlayerFrame.t())
        }
  @derive Jason.Encoder

  defstruct [
    :player,
    :frames
  ]
end
