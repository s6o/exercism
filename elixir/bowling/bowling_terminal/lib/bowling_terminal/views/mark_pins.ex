defmodule BowlingTerminal.Views.MarkPins do
  import Ratatouille.View
  import Ratatouille.Constants

  def render(_) do
    row do
      column(size: 12) do
        panel do
          table do
            table_row do
              table_cell(content: "Mark pins:", attributes: [attribute(:bold)])
              table_cell(content: "[ 0 ]")
              table_cell(content: "[ 1 ]")
              table_cell(content: "[ 2 ]")
              table_cell(content: "[ 3 ]")
              table_cell(content: "[ 4 ]")
              table_cell(content: "[ 5 ]")
              table_cell(content: "[ 6 ]")
              table_cell(content: "[ 7 ]")
              table_cell(content: "[ 8 ]")
              table_cell(content: "[ 9 ]")
              table_cell(content: "[ X ]", color: color(:green))
              table_cell(content: "[ / ]", color: color(:yellow))
            end
          end
        end
      end
    end
  end
end
