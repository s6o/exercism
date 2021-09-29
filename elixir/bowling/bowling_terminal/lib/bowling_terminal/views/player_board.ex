defmodule BowlingTerminal.Views.PlayerBoard do
  import Ratatouille.View
  import Ratatouille.Constants

  def render(%{"player" => player, "board_state" => _state, "frames" => frames}, is_active) do
    frame_map =
      frames
      |> Enum.with_index()
      |> Enum.map(fn {f, i} -> {i + 1, f} end)
      |> Map.new()

    render_frames =
      1..12
      |> Enum.map(fn frame_index ->
        {frame_title, fs1, fs2, fs, sr} =
          if Map.has_key?(frame_map, frame_index) do
            %{"slot1" => slot1, "slot2" => slot2, "slot_result" => slot_result, "score" => score} =
              Map.get(frame_map, frame_index)

            {" #{frame_index} ",
             if(is_nil(slot1), do: "_", else: if(slot1 < 10, do: to_string(slot1), else: "X")),
             if(is_nil(slot2),
               do: "_",
               else: if(slot1 + slot2 < 10, do: to_string(slot2), else: "/")
             ), if(is_nil(score), do: "__ ", else: to_string(score)), slot_result}
          else
            {" _ ", "_", "_", "__ ", "regular"}
          end

        column(size: 1) do
          panel(
            title: frame_title,
            color: if(is_active and frame_title != " _ ", do: color(:blue), else: nil),
            background: if(is_active and frame_title != " _ ", do: color(:white), else: nil)
          ) do
            label(content: " #{fs1}#{fs2}")
            label(content: "   ")

            label(
              content: fs,
              color:
                if(sr == "strike",
                  do: color(:green),
                  else: if(sr == "spare", do: color(:yellow), else: nil)
                )
            )
          end
        end
      end)

    panel(
      title: " #{player} ",
      color: if(is_active, do: color(:blue), else: nil),
      background: if(is_active, do: color(:white), else: nil)
    ) do
      row do
        for rf <- render_frames do
          rf
        end
      end
    end
  end
end
