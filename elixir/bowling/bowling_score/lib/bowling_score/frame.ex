defmodule BowlingScore.Frame do
  @type t :: %__MODULE__{
          pin_slots: {non_neg_integer() | :free, non_neg_integer() | :free},
          score: non_neg_integer(),
          slot_result: :regular | :spare | :strike
        }
  defstruct [
    :pin_slots,
    :score,
    :slot_result
  ]

  @spec create :: BowlingScore.Frame.t()
  def create() do
    %BowlingScore.Frame{pin_slots: {:free, :free}, score: 0, slot_result: :regular}
  end

  @spec mark_pins(
          frame :: {:ok, BowlingScore.Frame.t()} | BowlingScore.Frame.t(),
          pins :: non_neg_integer()
        ) ::
          {:ok, BowlingScore.Frame.t()} | {:error, atom()}
  def mark_pins({:ok, frame}, pins), do: mark_pins(frame, pins)

  def mark_pins(
        %BowlingScore.Frame{pin_slots: {:free, :free}, score: 0, slot_result: :regular} = frame,
        10 = pins
      ) do
    {:ok, %{frame | pin_slots: {pins, :free}, score: pins, slot_result: :strike}}
  end

  def mark_pins(
        %BowlingScore.Frame{pin_slots: {:free, :free}, score: 0, slot_result: :regular} = frame,
        pins
      )
      when pins >= 0 and pins <= 9 do
    {:ok, %{frame | pin_slots: {pins, :free}, score: pins}}
  end

  def mark_pins(
        %BowlingScore.Frame{pin_slots: {s1, :free}, score: score, slot_result: :regular} = frame,
        pins
      )
      when is_integer(s1) and s1 >= 0 and s1 <= 9 and pins > 0 and pins <= 10 - s1 do
    slot_result = if score + pins == 10, do: :spare, else: :regular
    {:ok, %{frame | pin_slots: {s1, pins}, score: score + pins, slot_result: slot_result}}
  end

  def mark_pins(_, _), do: {:error, :invalid_frame_or_pin_score}
end
