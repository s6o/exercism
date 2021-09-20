defmodule BowlingScore.Player do
  @type t :: %__MODULE__{
          name: String.t(),
          board: BowlingScore.Board.t()
        }
  defstruct [
    :name,
    :board
  ]

  @spec create(name :: String.t()) :: BowlingScore.Player.t()
  def create(name) do
    %BowlingScore.Player{
      name: name,
      board: BowlingScore.Board.create()
    }
  end
end
