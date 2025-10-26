defmodule IslandsEngine.GameSupervisor do
  use DynamicSupervisor

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_game(player_name) do
    DynamicSupervisor.start_child(__MODULE__, {IslandsEngine.Game, player_name})
  end

  def stop_game(player_name) do
    :ets.delete(:game_state, player_name)
    DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(player_name))
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp pid_from_name(player_name) do
    player_name
    |> IslandsEngine.Game.via_tuple()
    |> GenServer.whereis()
  end
end
