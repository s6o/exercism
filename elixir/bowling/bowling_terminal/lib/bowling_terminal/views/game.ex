defmodule BowlingTerminal.Views.Game do
  import Ratatouille.View

  def render(model) do
    state = Map.get(model.game, "game_state", "completed") |> String.replace("_", " ")

    viewport do
      BowlingTerminal.Views.MarkPins.render(model)

      row do
        column(size: 12) do
          panel(title: " Current Game [#{state}] ") do
            for {board, pi} <- model.game["board"] |> Enum.with_index() do
              BowlingTerminal.Views.PlayerBoard.render(board, model.game["active_player"] == pi)
            end
          end
        end
      end
    end
  end
end
