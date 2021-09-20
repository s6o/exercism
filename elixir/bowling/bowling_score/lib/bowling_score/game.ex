defmodule BowlingScore.Game do
  @type t :: %__MODULE__{
          players: list(BowlingScore.Player.t()),
          state: :registration | :in_progress | :completed
        }
  defstruct [
    :players,
    :state
  ]

  @spec create :: BowlingScore.Game.t()
  def create() do
    %BowlingScore.Game{
      players: [],
      state: :registration
    }
  end

  @spec add_player({:ok, BowlingScore.Game.t()} | BowlingScore.Game.t(), String.t()) ::
          BowlingScore.Game.t()
  def add_player({:ok, %BowlingScore.Game{} = g}, name), do: {:ok, add_player(g, name)}

  def add_player(%BowlingScore.Game{players: players, state: s} = game, name) do
    case s do
      :registration ->
        %{game | players: [BowlingScore.Player.create(name) | players]}

      _ ->
        {:error, :game_already_in_progress}
    end
  end
end
