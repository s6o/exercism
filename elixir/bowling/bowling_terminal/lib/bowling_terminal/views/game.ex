defmodule BowlingTerminal.Views.Game do
  import Ratatouille.View

  def render(_) do
    row do
      column(size: 12) do
        panel(title: " Current Game ") do
          # player boards
        end
      end
    end
  end
end
