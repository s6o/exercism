defmodule BowlingTerminal.Views.MainMenu do
  import Ratatouille.View
  # import Ratatouille.Constants

  def render(model) do
    row do
      column(size: 12) do
        panel do
          table do
            table_row do
              table_cell(content: "T#{model.terminal_id}")
              table_cell(content: "[Q]uit")
              table_cell(content: "[T]erminals")
              table_cell(content: "[N]ew Game")
            end
          end
        end
      end
    end
  end
end
