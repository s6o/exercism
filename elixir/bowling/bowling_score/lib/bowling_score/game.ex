defmodule BowlingScore.Game do
  @type t :: %__MODULE__{
          players: %{required(non_neg_integer) => BowlingScore.Player.t()},
          pindex: non_neg_integer(),
          state: :registration | :in_progress | :completed
        }
  defstruct [
    :players,
    :pindex,
    :state
  ]

  @spec create :: BowlingScore.Game.t()
  def create() do
    %BowlingScore.Game{
      players: %{},
      pindex: 0,
      state: :registration
    }
  end

  @doc """
  Register players to specified game.
  """
  @spec add_player({:ok, BowlingScore.Game.t()} | BowlingScore.Game.t(), String.t()) ::
          {:ok, BowlingScore.Game.t()} | {:error, :game_already_in_progress}
  def add_player({:ok, %BowlingScore.Game{} = g}, name), do: add_player(g, name)

  def add_player(%BowlingScore.Game{players: players, state: s} = game, name) do
    case s do
      :registration ->
        pcount = Enum.count(players) + 1
        {:ok, %{game | players: Map.put_new(players, pcount, BowlingScore.Player.create(name))}}

      _ ->
        {:error, :game_already_in_progress}
    end
  end

  @doc """
  Set game state :in_progrss and give first frame and ball roll to the player
  registered first.
  """
  @spec start({:ok, BowlingScore.Game.t()} | BowlingScore.Game.t()) ::
          {:ok, BowlingScore.Game.t()}
          | {:error, :game_missing_players | :game_has_already_started | :game_completed}
  def start({:ok, %BowlingScore.Game{} = g}), do: start(g)

  def start(%BowlingScore.Game{state: state} = game) do
    case state do
      :registration ->
        if Enum.count(game.players) == 0 do
          {:error, :game_missing_players}
        else
          {:ok, %{game | pindex: 1, state: :in_progress}}
        end

      :in_progress ->
        {:error, :game_has_already_started}

      _ ->
        {:error, :game_completed}
    end
  end

  @doc """
  Drive a game, by marking a pin result for the currently active player's frame.

  After a successful active player frame update select/activate the next player
  with frames/ball rolls left on the their board.

  If all players have completed their frames (board) the game is marked as :completed.
  """
  @spec mark_player_frame(
          {:ok, BowlingScore.Game.t()} | BowlingScore.Game.t(),
          0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10
        ) :: {:ok, BowlingScore.Game.t()} | {:error, atom}
  def mark_player_frame({:ok, %BowlingScore.Game{} = game}, pins)
      when is_integer(pins) and pins >= 0 and pins <= 10,
      do: mark_player_frame(game, pins)

  def mark_player_frame(%BowlingScore.Game{} = game, pins)
      when is_integer(pins) and pins >= 0 and pins <= 10 do
    if Map.has_key?(game.players, game.pindex) do
      %BowlingScore.Player{} = p = Map.get(game.players, game.pindex)

      with(
        {:ok, _} = active_frame <- BowlingScore.Board.active_frame(p.board),
        {:ok, _} = marked_frame <- BowlingScore.Board.mark_frame(active_frame, pins),
        {:ok, new_board} <- BowlingScore.Board.add_frame(marked_frame)
      ) do
        {:ok,
         Map.put(game.players, game.pindex, %{p | board: new_board})
         |> (fn m ->
               next_game = %{game | players: m}
               next_pindex = next_player(next_game)

               %{
                 next_game
                 | pindex: next_pindex,
                   state: if(next_pindex == 0, do: :completed, else: :in_progress)
               }
             end).()}
      end
    else
      {:error, :game_corrupted_player_index}
    end
  end

  defp next_player(%BowlingScore.Game{} = game) do
    game.players
    |> Map.keys()
    |> Enum.sort()
    |> (fn keys -> Enum.drop(keys, game.pindex) ++ Enum.take(keys, game.pindex) end).()
    |> Enum.reduce_while(0, fn pi, _ ->
      if Map.has_key?(game.players, pi) == true do
        player = Map.get(game.players, pi)

        if player.board.state != :completed do
          {:halt, pi}
        else
          {:cont, 0}
        end
      else
        {:cont, 0}
      end
    end)
  end
end
