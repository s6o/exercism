defmodule BowlingScore.Frame do
  @type t :: %__MODULE__{
          carries: list(non_neg_integer()),
          pin_slots: {non_neg_integer() | :free, non_neg_integer() | :free},
          slot_result: :regular | :spare | :strike
        }
  defstruct [
    :carries,
    :pin_slots,
    :slot_result
  ]

  @spec create :: BowlingScore.Frame.t()
  def create() do
    %BowlingScore.Frame{carries: [], pin_slots: {:free, :free}, slot_result: :regular}
  end

  @spec is_empty?(frame :: {:ok, BowlingScore.Frame.t()} | BowlingScore.Frame.t()) :: true | false
  def is_empty?({:ok, %BowlingScore.Frame{} = f}), do: is_empty?(f)

  def is_empty?(%BowlingScore.Frame{
        carries: [],
        pin_slots: {:free, :free},
        slot_result: :regular
      }),
      do: true

  def is_empty?(%BowlingScore.Frame{}), do: false

  @spec is_completed?(frame :: {:ok, BowlingScore.Frame.t()} | BowlingScore.Frame.t()) ::
          true | false
  def is_completed?({:ok, %BowlingScore.Frame{} = f}), do: is_completed?(f)

  def is_completed?(%BowlingScore.Frame{pin_slots: {s1, :free}, slot_result: :strike})
      when s1 == 10 do
    true
  end

  def is_completed?(%BowlingScore.Frame{pin_slots: {s1, s2}, slot_result: :spare})
      when s1 + s2 == 10 do
    true
  end

  def is_completed?(%BowlingScore.Frame{pin_slots: {s1, s2}, slot_result: :regular})
      when s1 + s2 >= 0 and s1 + s2 <= 9 do
    true
  end

  def is_completed?(%BowlingScore.Frame{}), do: false

  @spec mark_pins(
          frame :: {:ok, BowlingScore.Frame.t()} | BowlingScore.Frame.t(),
          pins :: non_neg_integer()
        ) ::
          {:ok, BowlingScore.Frame.t()} | {:error, atom()}
  def mark_pins({:ok, frame}, pins), do: mark_pins(frame, pins)

  def mark_pins(
        %BowlingScore.Frame{pin_slots: {:free, :free}, slot_result: :regular} = frame,
        10 = pins
      ) do
    {:ok, %{frame | pin_slots: {pins, :free}, slot_result: :strike}}
  end

  def mark_pins(
        %BowlingScore.Frame{pin_slots: {:free, :free}, slot_result: :regular} = frame,
        pins
      )
      when pins >= 0 and pins <= 9 do
    {:ok, %{frame | pin_slots: {pins, :free}}}
  end

  def mark_pins(
        %BowlingScore.Frame{pin_slots: {s1, :free}, slot_result: :regular} = frame,
        pins
      )
      when is_integer(s1) and s1 >= 0 and s1 <= 9 and pins >= 0 and s1 + pins <= 10 do
    slot_result = if s1 + pins == 10, do: :spare, else: :regular
    {:ok, %{frame | pin_slots: {s1, pins}, slot_result: slot_result}}
  end

  def mark_pins(_, _), do: {:error, :invalid_frame_or_pin_score}

  @spec score({:ok, BowlingScore.Frame.t()} | BowlingScore.Frame.t()) :: number
  def score({:ok, %BowlingScore.Frame{} = f}), do: score(f)

  def score(%BowlingScore.Frame{carries: carries, pin_slots: {s1, :free}, slot_result: :strike}) do
    s1 + Enum.sum(carries)
  end

  def score(%BowlingScore.Frame{carries: carries, pin_slots: {s1, s2}})
      when is_integer(s1) and is_integer(s2) do
    s1 + s2 + Enum.sum(carries)
  end

  def score(%BowlingScore.Frame{}), do: 0

  @spec set_carries(
          frame :: {:ok, BowlingScore.Frame.t()} | BowlingScore.Frame.t(),
          carries :: list(non_neg_integer())
        ) ::
          {:ok, BowlingScore.Frame.t()} | BowlingScore.Frame.t()
  def set_carries({:ok, %BowlingScore.Frame{} = f}, carries) do
    {:ok, %{f | carries: carries}}
  end

  def set_carries(%BowlingScore.Frame{} = f, carries) do
    %{f | carries: carries}
  end
end
