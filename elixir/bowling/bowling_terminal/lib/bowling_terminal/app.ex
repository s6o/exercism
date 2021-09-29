defmodule BowlingTerminal.App do
  @behaviour Ratatouille.App

  require Kernel
  import Ratatouille.View
  import Ratatouille.Constants

  alias Ratatouille.Runtime.{Command, Subscription}
  alias BowlingTerminal.GameServer

  @escape key(:esc)
  @backspace key(:backspace2)
  @enter key(:enter)

  @impl true
  def init(%{window: window}) do
    model = %{
      error: "",
      terminal_id: 0,
      terminals: [],
      overlay: nil,
      new_game: %{
        player_entry: "",
        players: []
      },
      game: %{},
      window: window
    }

    {model, Command.new(fn -> GameServer.register() end, :terminal_id)}
  end

  @impl true
  def subscribe(_model) do
    Subscription.interval(1_000, :tick)
  end

  @impl true
  def update(model, msg) do
    case msg do
      ## Terminal events
      {:resize, event} ->
        %{h: height, w: width} = event
        %{model | window: %{height: height, width: width}}

      {:terminal_id, data} ->
        case data do
          {:ok, %{"terminal_id" => tid}} -> %{model | terminal_id: tid}
          _ -> %{model | error: "Could not register terminal, maybe server is down ..."}
        end

      {:terminals, data} ->
        case data do
          {:ok, terminals} -> %{model | terminals: terminals}
          _ -> model
        end

      ## Game events
      {:new_game, data} ->
        case data do
          {:ok, game} -> %{model | game: game}
          _ -> model
        end

      {:game_state, data} ->
        case data do
          {:ok, game} -> %{model | game: game}
          _ -> model
        end

      ## Mark pins
      {:event, %{ch: ch} = event}
      when ch in [?0, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?x, ?X, ?/] and is_nil(model.overlay) ->
        mark_pins_event(model, event)

      ## Main menu overlays
      {:event, %{ch: ch}} when ch in [?t, ?T] and is_nil(model.overlay) ->
        %{model | overlay: :terminals}

      {:event, %{ch: ch}} when ch in [?n, ?N] and is_nil(model.overlay) ->
        %{model | overlay: :new_game}

      {:event, event} when model.overlay == :new_game ->
        player_entry(model, event)

      {:event, event} when not is_nil(model.overlay) ->
        overlay_key(model, event)

      ## Handle tick:

      :tick ->
        if game_on?(model) do
          {model,
           Command.batch([
             Command.new(fn -> GameServer.terminals() end, :terminals),
             Command.new(fn -> GameServer.game_state(model.terminal_id) end, :game_state)
           ])}
        else
          {model, Command.new(fn -> GameServer.terminals() end, :terminals)}
        end

      _ ->
        model
    end
  end

  @impl true
  def render(model) do
    view(bottom_bar: error_bar(model)) do
      BowlingTerminal.Views.MainMenu.render(model)

      if game_on?(model) or game_completed?(model) do
        BowlingTerminal.Views.Game.render(model)
      end

      case model.overlay do
        :terminals -> BowlingTerminal.Views.Terminals.render(model)
        :new_game -> BowlingTerminal.Views.NewGame.render(model)
        _ -> nil
      end
    end
  end

  defp game_on?(model) do
    Map.has_key?(model.game, "game_state") && Map.get(model.game, "game_state") == "in_progress" &&
      Enum.count(Map.keys(model.game)) > 0
  end

  defp game_completed?(model) do
    Map.has_key?(model.game, "game_state") && Map.get(model.game, "game_state") == "completed" &&
      Enum.count(Map.keys(model.game)) > 0
  end

  defp error_bar(model) do
    bar do
      label(content: model.error, color: color(:red))
    end
  end

  defp mark_pins_event(model, %{ch: pins}) when pins in [?x, ?X] do
    if game_on?(model) do
      if frame_slot_score(model) == 0 do
        {%{model | error: ""},
         Command.new(fn -> GameServer.mark_pins(model.terminal_id, 10) end, :game_state)}
      else
        %{model | error: "Invalid pin pick."}
      end
    else
      model
    end
  end

  defp mark_pins_event(model, %{ch: pins}) when pins in [?/] do
    if game_on?(model) do
      frame_score = frame_slot_score(model)

      if frame_score > 0 and frame_score < 10 do
        remaining_pins = 10 - frame_score

        {%{model | error: ""},
         Command.new(
           fn -> GameServer.mark_pins(model.terminal_id, remaining_pins) end,
           :game_state
         )}
      else
        %{model | error: "Invalid pin pick."}
      end
    else
      model
    end
  end

  defp mark_pins_event(model, %{ch: pins}) do
    if game_on?(model) do
      pins_down = pins - 48
      frame_score = frame_slot_score(model)

      if frame_score >= 0 and frame_score < 10 and frame_score + pins_down < 10 do
        {%{model | error: ""},
         Command.new(fn -> GameServer.mark_pins(model.terminal_id, pins_down) end, :game_state)}
      else
        %{model | error: "Invalid pin pick."}
      end
    else
      model
    end
  end

  defp frame_slot_score(%{game: %{"active_player" => ap, "board" => board}}) do
    %{"frames" => frames} = Enum.at(board, ap)
    %{"slot1" => s1, "slot2" => s2} = Enum.at(frames, Enum.count(frames) - 1)
    if(is_nil(s1), do: 0, else: s1) + if(is_nil(s2), do: 0, else: s2)
  end

  defp overlay_key(model, %{key: @escape}), do: %{model | overlay: nil}

  defp overlay_key(model, _), do: model

  def player_entry(model, %{key: @enter}) do
    if model.new_game.player_entry == "" && Enum.count(model.new_game.players) > 0 do
      {%{model | overlay: nil},
       Command.new(
         fn -> GameServer.new_game(model.terminal_id, model.new_game.players) end,
         :new_game
       )}
    else
      put_in(
        model,
        [:new_game, :players],
        model.new_game.players ++ [model.new_game.player_entry]
      )
      |> put_in([:new_game, :player_entry], "")
    end
  end

  def player_entry(model, %{key: @escape}) do
    put_in(model, [:overlay], nil)
    |> put_in([:new_game, :player_entry], "")
  end

  def player_entry(model, %{key: @backspace}) do
    put_in(model, [:new_game, :player_entry], String.slice(model.new_game.player_entry, 0..-2))
  end

  def player_entry(model, %{ch: ch}) when ch > 0 do
    put_in(model, [:new_game, :player_entry], model.new_game.player_entry <> <<ch::utf8>>)
  end

  def search(model, _event) do
    model
  end
end
