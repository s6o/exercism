defmodule IslandsEngine.Game do
  use GenServer

  alias IslandsEngine.Board
  alias IslandsEngine.Coordinate
  alias IslandsEngine.Guesses
  alias IslandsEngine.Island
  alias IslandsEngine.Rules

  @players [:player1, :player2]
  @timeout 10 * 60 * 1000

  def child_spec(player_name) when is_binary(player_name),
    do: %{
      id: __MODULE__,
      restart: :transient,
      start: {__MODULE__, :start_link, [player_name]}
    }

  def start_link(player_name) when is_binary(player_name),
    do: GenServer.start_link(__MODULE__, player_name, name: via_tuple(player_name))

  def add_player(game, player_name) when is_binary(player_name),
    do: GenServer.call(game, {:add_player, player_name})

  def position_island(game, player, shape, row, col)
      when player in @players and is_atom(shape) and is_integer(row) and is_integer(col),
      do: GenServer.call(game, {:position_island, player, shape, row, col})

  def set_islands(game, player) when player in @players,
    do: GenServer.call(game, {:set_islands, player})

  def guess_coordinate(game, player, row, col)
      when player in @players and is_integer(row) and is_integer(col),
      do: GenServer.call(game, {:guess_coordinate, player, row, col})

  def via_tuple(player_name) do
    {:via, Registry, {Registry.Game, "#{player_name}"}}
  end

  def init(player_name) do
    player1 = %{name: player_name, board: Board.new(), guesses: Guesses.new()}
    player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}
    {:ok, %{player1: player1, player2: player2, rules: Rules.new()}, @timeout}
  end

  def handle_call({:add_player, player_name}, _from, state) do
    with {:ok, rules} <- Rules.check(state.rules, :add_player) do
      state
      |> (fn s -> put_in(s.player2.name, player_name) end).()
      |> (fn s -> put_in(s.rules, rules) end).()
      |> reply_tuple(:ok)
    else
      e -> reply_tuple(state, e)
    end
  end

  def handle_call({:position_island, player, shape, row, col}, _from, state) do
    with {:ok, rules} <- Rules.check(state.rules, {:position_islands, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         {:ok, island} <- Island.new(shape, coordinate),
         {:ok, board} <- Board.position_island(player_board(state, player), island) do
      state
      |> (fn s -> put_in(s, [player, :board], board) end).()
      |> (fn s -> put_in(s.rules, rules) end).()
      |> reply_tuple(:ok)
    else
      e -> reply_tuple(state, e)
    end
  end

  def handle_call({:set_islands, player}, _from, state) do
    with {:ok, rules} <- Rules.check(state.rules, {:set_islands, player}),
         true <- Board.all_islands_positioned?(player_board(state, player)) do
      state
      |> (fn s -> put_in(s.rules, rules) end).()
      |> reply_tuple(:ok)
    else
      false ->
        reply_tuple(state, {:error, :not_all_islands_positioned})

      e ->
        reply_tuple(state, e)
    end
  end

  def handle_call({:guess_coordinate, player, row, col}, _from, state) do
    with {:ok, rules} <- Rules.check(state.rules, {:guess_coordinate, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         opponent_board <- player_board(state, opponent(player)),
         {hit_or_miss, forested_island, win_status, updated_board} <-
           Board.guess(opponent_board, coordinate),
         {:ok, rules} <- Rules.check(rules, {:win_check, win_status}) do
      state
      |> (fn s -> put_in(s, [opponent(player), :board], updated_board) end).()
      |> (fn s ->
            put_in(
              s,
              [player, :guesses],
              Guesses.add(Map.get(state, player).guesses, hit_or_miss, coordinate)
            )
          end).()
      |> (fn s -> put_in(s.rules, rules) end).()
      |> reply_tuple({hit_or_miss, forested_island, win_status})
    else
      e -> reply_tuple(state, e)
    end
  end

  def handle_info(:timeout, state) do
    {:stop, {:shutdown, :timeout}, state}
  end

  defp opponent(:player1), do: :player2
  defp opponent(:player2), do: :player1

  defp player_board(state, player), do: Map.get(state, player).board

  defp reply_tuple(state, response), do: {:reply, response, state, @timeout}
end
