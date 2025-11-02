defmodule IslandsInterfaceWeb.GameChannel do
  use IslandsInterfaceWeb, :channel

  alias IslandsEngine.Game
  alias IslandsEngine.GameSupervisor
  alias IslandsInterfaceWeb.Endpoint
  alias IslandsInterfaceWeb.Presence

  @impl true
  def join("game:lobby", payload, socket) do
    if authorized?(payload) do
      payload =
        players_waiting()
        |> players_payload()

      {:ok, payload, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("game:" <> player, payload, socket) do
    if authorized?(payload) do
      send(self(), {:after_join, player})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("show_subscribers", _payload, socket) do
    broadcast!(socket, "subscribers", Presence.list(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_in("new_game", %{"player" => player}, socket) do
    case GameSupervisor.start_game(player) do
      {:ok, _pid} ->
        players_waiting()
        |> broadcast_players!()

        {:reply, :ok, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
    end
  end

  @impl true
  def handle_in("add_player", %{"player1" => player1, "player2" => player2}, socket) do
    case Game.add_player(Game.via_tuple(player1), player2) do
      :ok ->
        players_waiting()
        |> broadcast_players!()

        payload =
          %{
            "#{player1}" => "Position islands.",
            "#{player2}" => "Wait for #{player1} to position islands ..."
          }

        broadcast_game!(player1, "players_added", payload)

        {:reply, :ok, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}

      :error ->
        {:reply, :error, socket}
    end
  end

  @impl true
  def handle_info({:after_join, screen_name}, socket) do
    {:ok, _} =
      Presence.track(socket, screen_name, %{
        online_at: inspect(System.system_time(:second))
      })

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp players_waiting() do
    Supervisor.which_children(GameSupervisor)
    |> Enum.map(fn {_, pid, _, _} -> :sys.get_state(pid) end)
    |> Enum.filter(fn s -> s.rules.state == :initialized end)
    |> Enum.map(fn s -> s.player1.name end)
  end

  defp players_payload(players), do: %{"players" => Enum.join(players, ", ")}

  defp broadcast_players!(players) do
    Endpoint.broadcast!("game:lobby", "games_waiting", players_payload(players))
  end

  defp broadcast_game!(player1, event, payload) do
    Endpoint.broadcast!("game:" <> player1, event, payload)
  end
end
