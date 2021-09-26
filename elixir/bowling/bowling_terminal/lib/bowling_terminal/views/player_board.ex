defmodule BowlingTerminal.Views.PlayerBoard do
  import Ratatouille.View

  def render(_) do
    panel(title: "Alice") do
      row do
        column(size: 1) do
          panel(title: " 1 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 2 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 3 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 4 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 5 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 6 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 7 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 8 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 9 ") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 10") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 11") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end

        column(size: 1) do
          panel(title: " 12") do
            label(content: " X ")
            label(content: "   ")
            label(content: "10 ")
          end
        end
      end
    end
  end
end
