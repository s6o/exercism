defmodule BowlingTerminal.Views.NewGame do
  import Ratatouille.View
  # import Ratatouille.Constants

  def render(_model) do
    overlay(padding: 5) do
      panel(title: "New Game, add players (<ESC> to close)", height: :fill) do
      end
    end
  end
end
