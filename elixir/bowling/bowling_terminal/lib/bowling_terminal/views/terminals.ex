defmodule BowlingTerminal.Views.Terminals do
  import Ratatouille.View
  import Ratatouille.Constants

  def render(model) do
    overlay(padding: 5) do
      panel(title: "Terminals (<ESC> to close)", height: :fill) do
        table do
          for %{"state" => state, "terminal_id" => tid} <- model.terminals do
            table_row(if state == "vacant", do: [color: color(:green)], else: []) do
              table_cell(content: "#{String.pad_leading(to_string(tid), 3)} - #{state}")
            end
          end
        end
      end
    end
  end
end
