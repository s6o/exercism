defmodule BowlingHall.TerminalPlayerFrame do
  @type t :: %__MODULE__{
          slot1: nil | non_neg_integer(),
          slot2: nil | non_neg_integer(),
          slot_result: String.t(),
          score: nil | non_neg_integer()
        }
  @derive Jason.Encoder

  defstruct [
    :slot1,
    :slot2,
    :slot_result,
    :score
  ]
end
