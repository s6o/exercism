defmodule BowlingTerminal.App do
  @behaviour Ratatouille.App

  require Kernel
  import Ratatouille.View
  import Ratatouille.Constants

  alias Ratatouille.Runtime.{Command, Subscription}
  alias BowlingTerminal.GameServer

  @escape key(:esc)

  @impl true
  def init(%{window: window}) do
    model = %{
      error: "",
      terminal_id: 0,
      terminals: [],
      overlay: nil,
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

      {:resize, event} ->
        %{h: height, w: width} = event
        %{model | window: %{height: height, width: width}}

      ## Main menu overlays
      {:event, %{ch: ch}} when ch in [?t, ?T] and is_nil(model.overlay) ->
        %{model | overlay: :terminals}

      {:event, %{ch: ch}} when ch in [?n, ?N] and is_nil(model.overlay) ->
        %{model | overlay: :new_game}

      {:event, event} when not is_nil(model.overlay) ->
        overlay_key(model, event)

      ## Handle tick:

      :tick ->
        {model, Command.new(fn -> GameServer.terminals() end, :terminals)}

      _ ->
        model
    end
  end

  @impl true
  def render(model) do
    view(bottom_bar: error_bar(model)) do
      BowlingTerminal.Views.MainMenu.render(model)

      if Enum.count(Map.keys(model.game)) > 0 do
        BowlingTerminal.Views.MarkPins.render(model)

        BowlingTerminal.Views.Game.render(model)
      end

      case model.overlay do
        :terminals -> BowlingTerminal.Views.Terminals.render(model)
        :new_game -> BowlingTerminal.Views.NewGame.render(model)
        _ -> nil
      end
    end
  end

  defp error_bar(model) do
    bar do
      label do
        text(content: model.error, color: color(:red))
      end
    end
  end

  defp overlay_key(model, %{key: @escape}), do: %{model | overlay: nil}

  defp overlay_key(model, _), do: model
end
