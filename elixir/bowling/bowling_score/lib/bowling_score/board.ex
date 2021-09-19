defmodule BowlingScore.Board do
  @type t :: %__MODULE__{
          frames: list(BowlingScore.Frame.t()),
          score: non_neg_integer(),
          state: :in_progress | :strike_bonus | :spare_bonus | :completed
        }
  defstruct [
    :frames,
    :score,
    :state
  ]

  @doc """
  Create a score board with an initial empty BowlingScore.Frame.t.
  """
  @spec create :: BowlingScore.Board.t()
  def create() do
    %BowlingScore.Board{frames: [BowlingScore.Frame.create()], score: 0, state: :in_progress}
  end

  @spec active_frame(board :: {:ok, BowlingScore.Board.t()} | BowlingScore.Board.t()) ::
          {BowlingScore.Frame.t(), BowlingScore.Board.t()}
  def active_frame({:ok, %BowlingScore.Board{} = b}), do: active_frame(b)
  def active_frame(%BowlingScore.Board{frames: [f]} = b), do: {f, b}
  def active_frame(%BowlingScore.Board{frames: [f | _]} = b), do: {f, b}

  @doc """
  Update BowlingScore.Board.active_frame/1 result with pin count.
  """
  @spec mark_frame(
          {BowlingScore.Frame.t(), BowlingScore.Board.t()},
          0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10
        ) ::
          {{:error, :invalid_frame_or_pin_score} | {:ok, BowlingScore.Frame.t()},
           BowlingScore.Board.t()}
  def mark_frame({%BowlingScore.Frame{} = f, %BowlingScore.Board{} = board}, pins)
      when is_integer(pins) and pins >= 0 and pins <= 10 do
    {BowlingScore.Frame.mark_pins(f, pins), board}
  end

  @doc """
  Add a BowlingScore.mark_frame/1 marked frame to board by replacing the current
  active empty ("head") frame or replace the current active partial ("head") frame
  and add a new empty frame as a new active frame.

  After previous frame completion a new empty active frame is added only if board
  scoring is not complete.

  ## Example of scoring board's active frame with pins 7 (first throw) and 2 (second throw)

      board =
        BowlingScore.Board.create()
        |> BowlingScore.Board.active_frame()
        |> BowlingScore.Board.mark_frame(7)
        |> BowlingScore.Board.add_frame()
        |> BowlingScore.Board.active_frame()
        |> BowlingScore.Board.mark_frame(2)
        |> BowlingScore.Board.add_frame()
  """
  @spec add_frame(frame_board :: {BowlingScore.Frame.t(), BowlingScore.Board.t()}) ::
          {:ok, BowlingScore.Board.t()} | {:error, atom()}
  def add_frame({{:ok, %BowlingScore.Frame{} = sf}, %BowlingScore.Board{} = b}),
    do: add_frame({sf, b})

  def add_frame(
        {%BowlingScore.Frame{} = scored_frame, %BowlingScore.Board{frames: frames} = board}
      ) do
    if BowlingScore.Frame.is_empty?(scored_frame) do
      {:error, :invalid_empty_frame}
    else
      {active_frame, prev_frames} =
        case frames do
          [af] -> {af, []}
          [af | t] -> {af, t}
        end

      frame_count = frames |> Enum.count()

      case board.state do
        :completed ->
          {:error, :board_completed}

        :strike_bonus ->
          case scored_frame do
            %BowlingScore.Frame{slot_result: :strike} when frame_count < 12 ->
              %{board | frames: [BowlingScore.Frame.create() | [scored_frame | prev_frames]]}

            _ ->
              %{
                board
                | frames: [scored_frame | prev_frames],
                  state:
                    if(BowlingScore.Frame.is_completed?(scored_frame),
                      do: :completed,
                      else: :strike_bonus
                    )
              }
          end
          |> update_board()

        :spare_bonus ->
          {bonus_pins, _} = scored_frame.pin_slots
          final_frame = %{scored_frame | pin_slots: {bonus_pins, 0}, slot_result: :regular}

          %{board | frames: [final_frame | prev_frames], state: :completed}
          |> update_board()

        :in_progress ->
          case active_frame do
            %BowlingScore.Frame{pin_slots: {:free, :free}, slot_result: :regular} ->
              case scored_frame do
                %BowlingScore.Frame{slot_result: :strike} ->
                  %{
                    board
                    | frames: [BowlingScore.Frame.create() | [scored_frame | prev_frames]],
                      state: if(frame_count == 10, do: :strike_bonus, else: :in_progress)
                  }
                  |> update_board()

                _ ->
                  if BowlingScore.Frame.is_completed?(scored_frame) do
                    {:error, :invalid_completed_frame_expecting_partial}
                  else
                    %{board | frames: [scored_frame | prev_frames]}
                    |> update_board()
                  end
              end

            %BowlingScore.Frame{pin_slots: {_, :free}, slot_result: :regular} ->
              if BowlingScore.Frame.is_completed?(scored_frame) do
                case scored_frame do
                  %BowlingScore.Frame{slot_result: :spare} when frame_count == 10 ->
                    %{
                      board
                      | frames: [BowlingScore.Frame.create() | [scored_frame | prev_frames]],
                        state: :spare_bonus
                    }

                  %BowlingScore.Frame{slot_result: :regular} when frame_count == 10 ->
                    %{board | frames: [scored_frame | prev_frames], state: :completed}

                  %BowlingScore.Frame{} ->
                    %{
                      board
                      | frames: [BowlingScore.Frame.create() | [scored_frame | prev_frames]],
                        state: :in_progress
                    }
                end
                |> update_board()
              else
                {:error, :invalid_partial_frame_expecting_completed}
              end

            _ ->
              {:error, :invalid_frame_or_board}
          end
      end
    end
  end

  def add_frame({_, _}), do: {:error, :invalid_frame_or_board}

  defp update_board(%BowlingScore.Board{frames: frames} = board) do
    completed_frames = Enum.filter(frames, &BowlingScore.Frame.is_completed?/1)

    updated_frames =
      if Enum.count(completed_frames) < 2 do
        frames
      else
        frame_lookahead =
          completed_frames
          |> Enum.with_index()
          |> Enum.map(fn {e, i} -> {i, e} end)
          |> Map.new()

        # |> IO.inspect(label: "lookahead")

        completed_frames
        |> Enum.with_index()
        |> Enum.reduce({[], []}, fn {frame, index}, {carries, accum} ->
          new_carries =
            case Map.get(frame_lookahead, index + 1, %{}) do
              %BowlingScore.Frame{slot_result: :strike} ->
                case frame do
                  %BowlingScore.Frame{pin_slots: {s1, _}, slot_result: :strike} ->
                    [s1] ++ Enum.take(carries, 1)

                  %BowlingScore.Frame{pin_slots: {s1, s2}}
                  when is_integer(s1) and is_integer(s2) ->
                    [s1, s2]

                  _ ->
                    []
                end

              %BowlingScore.Frame{slot_result: :spare} ->
                {pin_score, _} = frame.pin_slots
                [pin_score] ++ Enum.take(carries, 1)

              _ ->
                []
            end

          {new_carries, accum ++ [BowlingScore.Frame.set_carries(frame, carries)]}
          # |> IO.inspect(label: "{carries, frames}")
        end)
        |> (fn {_, uf} ->
              Enum.filter(frames, fn f ->
                f |> BowlingScore.Frame.is_completed?() |> Kernel.not()
              end) ++
                uf
            end).()
      end

    board_score =
      updated_frames
      |> Enum.reverse()
      |> Enum.take(10)
      |> Enum.reduce(0, fn frame, sum -> sum + BowlingScore.Frame.score(frame) end)

    {:ok, %{board | frames: updated_frames, score: board_score}}
  end
end
