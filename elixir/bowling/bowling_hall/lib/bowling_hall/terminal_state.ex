defmodule BowlingHall.TerminalState do
  @type t :: %__MODULE__{
          terminal_id: pos_integer(),
          state: String.t()
        }
  @derive Jason.Encoder

  defstruct [
    :terminal_id,
    :state
  ]
end
