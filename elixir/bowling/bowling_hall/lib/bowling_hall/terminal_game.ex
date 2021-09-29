defmodule BowlingHall.TerminalGame do
  @type t :: %__MODULE__{
          active_player: non_neg_integer(),
          board: list(BowlingHall.TerminalPlayer.t()),
          game_state: String.t()
        }
  @derive Jason.Encoder

  defstruct [
    :active_player,
    :board,
    :game_state
  ]

  @spec create({:ok, BowlingScore.Game.t()} | BowlingScore.Game.t()) ::
          BowlingHall.TerminalGame.t()
  def create({:ok, %BowlingScore.Game{} = g}), do: create(g)

  def create(%BowlingScore.Game{} = game) do
    %BowlingHall.TerminalGame{
      active_player: game.pindex - 1,
      game_state: if(game.state == :completed, do: "completed", else: "in_progress"),
      board:
        game.players
        |> Map.keys()
        |> Enum.sort()
        |> Enum.map(fn player_index ->
          %BowlingScore.Player{} = player = Map.get(game.players, player_index)

          %BowlingHall.TerminalPlayer{
            player: player.name,
            board_state:
              if(player.board.state == :completed, do: "completed", else: "in_progress"),
            frames:
              BowlingScore.Board.running_score(player.board)
              |> Enum.map(fn {%BowlingScore.Frame{} = f, score} ->
                {ps1, ps2} = f.pin_slots

                %BowlingHall.TerminalPlayerFrame{
                  slot1: if(ps1 == :free, do: nil, else: ps1),
                  slot2: if(ps2 == :free, do: nil, else: ps2),
                  slot_result: to_string(f.slot_result),
                  score: if(ps1 == :free && ps2 == :free, do: nil, else: score)
                }
              end)
          }
        end)
    }
  end
end
