defmodule BowlingHall.GameServer do
  @moduledoc """
  Keep a list of terminal ID-s and their respective games.
  The game server state is a map where keys are terminal ID-s and values are
  BowlingScore.Game.t()
  """
  use GenServer

  # Client interface

  def start_link(default) when is_map(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @spec register_terminal(pos_integer()) :: :ok | :conflict
  def register_terminal(terminal_id) do
    GenServer.call(BowlingHall.GameServer, {:register_terminal, terminal_id})
  end

  @spec list_terminals :: list(BowlingHall.TerminalState.t())
  def list_terminals() do
    GenServer.call(BowlingHall.GameServer, :list_terminals)
  end

  @spec new_game(pos_integer(), list(String.t())) ::
          BowlingHall.TerminalGame.t() | :unknown_terminal
  def new_game(terminal_id, players) do
    GenServer.call(BowlingHall.GameServer, {:new_game, terminal_id, players})
  end

  @spec game_state(pos_integer()) :: BowlingHall.TerminalGame.t() | :no_game | :unknown_terminal
  def game_state(terminal_id) do
    GenServer.call(BowlingHall.GameServer, {:game_state, terminal_id})
  end

  @spec mark_pins(pos_integer(), non_neg_integer()) ::
          BowlingHall.TerminalGame.t() | :no_game | :unknown_terminal | {:error, String.t()}
  def mark_pins(terminal_id, pins) do
    GenServer.call(BowlingHall.GameServer, {:mark_pins, terminal_id, pins})
  end

  # Server implementation

  @impl true
  @spec init(map) :: {:ok, %{required(pos_integer()) => BowlingScore.Game.t()}}
  def init(%{} = games) do
    {:ok, games}
  end

  @impl true
  def handle_call({:register_terminal, terminal_id}, _from, games) do
    if Map.has_key?(games, terminal_id) do
      {:reply, :conflict, games}
    else
      {:reply, :ok, Map.put_new(games, terminal_id, %{})}
    end
  end

  @impl true
  def handle_call(:list_terminals, _from, games) do
    {:reply,
     games
     |> Enum.map(fn {k, v} ->
       %BowlingHall.TerminalState{
         terminal_id: k,
         state: if(map_size(v) == 0, do: "vacant", else: "occupied")
       }
     end), games}
  end

  @impl true
  def handle_call({:new_game, terminal_id, players}, _from, games) do
    if Map.has_key?(games, terminal_id) do
      {:ok, new_game} =
        players
        |> Enum.reduce(BowlingScore.Game.create(), fn name, game ->
          BowlingScore.Game.add_player(game, name)
        end)
        |> BowlingScore.Game.start()

      {:reply, BowlingHall.TerminalGame.create(new_game), Map.put(games, terminal_id, new_game)}
    else
      {:reply, :unknown_terminal, games}
    end
  end

  @impl true
  def handle_call({:game_state, terminal_id}, _from, games) do
    if Map.has_key?(games, terminal_id) do
      case Map.get(games, terminal_id) do
        %BowlingScore.Game{} = game ->
          {:reply, BowlingHall.TerminalGame.create(game), games}

        _ ->
          {:reply, :no_game, games}
      end
    else
      {:reply, :unknown_terminal, games}
    end
  end

  def handle_call({:mark_pins, terminal_id, pins}, _from, games) do
    if Map.has_key?(games, terminal_id) do
      case Map.get(games, terminal_id) do
        %BowlingScore.Game{} = game ->
          with {:ok, g} <- BowlingScore.Game.mark_player_frame(game, pins) do
            {:reply, BowlingHall.TerminalGame.create(g), Map.put(games, terminal_id, g)}
          end

        _ ->
          {:reply, :no_game, games}
      end
    else
      {:reply, :unknown_terminal, games}
    end
  end
end
