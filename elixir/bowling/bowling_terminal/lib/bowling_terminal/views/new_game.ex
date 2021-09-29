defmodule BowlingTerminal.Views.NewGame do
  import Ratatouille.View

  def render(model) do
    overlay(padding: 5) do
      panel(title: "New Game, add players (<ESC> to close)", height: :fill) do
        table do
          table_row do
            table_cell(content: "Enter player: " <> model.new_game.player_entry)
          end

          table_row do
            table_cell(content: "")
          end

          table_row do
            table_cell(
              content:
                if(model.new_game.player_entry == "" && Enum.count(model.new_game.players) > 0,
                  do: "To start, press Enter, or type/add another player",
                  else: ""
                )
            )
          end

          table_row do
            table_cell(content: "")
          end

          table_row do
            table_cell(content: "List of players")
          end

          for player <- model.new_game.players do
            table_row do
              table_cell(content: String.pad_leading("", 5) <> player)
            end
          end
        end
      end
    end
  end
end
