defmodule BowlingScore.FrameTest do
  use ExUnit.Case

  test "new frame" do
    assert BowlingScore.Frame.create() == %BowlingScore.Frame{
             carries: [],
             pin_slots: {:free, :free},
             slot_result: :regular
           }
  end

  test "a new frame is an empty frame" do
    assert BowlingScore.Frame.create() |> BowlingScore.Frame.is_empty?() == true
    assert {:ok, BowlingScore.Frame.create()} |> BowlingScore.Frame.is_empty?() == true

    assert BowlingScore.Frame.create()
           |> BowlingScore.Frame.mark_pins(7)
           |> BowlingScore.Frame.is_empty?() == false
  end

  test "a completed frame" do
    assert BowlingScore.Frame.create()
           |> BowlingScore.Frame.mark_pins(10)
           |> BowlingScore.Frame.is_completed?() == true

    assert BowlingScore.Frame.create()
           |> BowlingScore.Frame.mark_pins(7)
           |> BowlingScore.Frame.is_completed?() == false

    assert BowlingScore.Frame.create()
           |> BowlingScore.Frame.mark_pins(7)
           |> BowlingScore.Frame.mark_pins(3)
           |> BowlingScore.Frame.is_completed?() == true

    assert BowlingScore.Frame.create()
           |> BowlingScore.Frame.mark_pins(5)
           |> BowlingScore.Frame.mark_pins(3)
           |> BowlingScore.Frame.is_completed?() == true
  end

  test "valid strike scoring" do
    frame = BowlingScore.Frame.create()

    assert BowlingScore.Frame.mark_pins(frame, 10) ==
             {:ok,
              %BowlingScore.Frame{
                carries: [],
                pin_slots: {10, :free},
                slot_result: :strike
              }}
  end

  test "strike frame is closed for additional scoring" do
    strike_frame =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(10)

    assert BowlingScore.Frame.mark_pins(strike_frame, 10) ==
             {:error, :invalid_frame_or_pin_score}

    assert BowlingScore.Frame.mark_pins(strike_frame, 0) == {:error, :invalid_frame_or_pin_score}
    assert BowlingScore.Frame.mark_pins(strike_frame, 3) == {:error, :invalid_frame_or_pin_score}
    assert BowlingScore.Frame.mark_pins(strike_frame, 7) == {:error, :invalid_frame_or_pin_score}

    fake_strike =
      BowlingScore.Frame.create()
      |> (fn f -> %{f | slot_result: :strike} end).()

    assert BowlingScore.Frame.mark_pins(fake_strike, 4) == {:error, :invalid_frame_or_pin_score}
  end

  test "valid regular scoring" do
    frame = BowlingScore.Frame.create()

    assert BowlingScore.Frame.mark_pins(frame, 7) ==
             {:ok,
              %BowlingScore.Frame{
                carries: [],
                pin_slots: {7, :free},
                slot_result: :regular
              }}
  end

  test "valid regular scoring ending in spare" do
    frame =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)

    assert frame ==
             {:ok,
              %BowlingScore.Frame{
                carries: [],
                pin_slots: {7, :free},
                slot_result: :regular
              }}

    assert BowlingScore.Frame.mark_pins(frame, 3) ==
             {:ok,
              %BowlingScore.Frame{
                carries: [],
                pin_slots: {7, 3},
                slot_result: :spare
              }}
  end

  test "valid regular scoring ending in regular frame" do
    frame =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)
      |> BowlingScore.Frame.mark_pins(2)

    assert frame ==
             {:ok, %BowlingScore.Frame{carries: [], pin_slots: {7, 2}, slot_result: :regular}}
  end

  test "invalid regular and spare scoring ends with error" do
    frame =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)

    assert BowlingScore.Frame.mark_pins(frame, 4) == {:error, :invalid_frame_or_pin_score}

    frame1 = BowlingScore.Frame.create()
    assert BowlingScore.Frame.mark_pins(frame1, 11) == {:error, :invalid_frame_or_pin_score}

    frame2 =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)
      |> BowlingScore.Frame.mark_pins(2)

    assert BowlingScore.Frame.mark_pins(frame2, 1) == {:error, :invalid_frame_or_pin_score}

    spare_frame =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)
      |> BowlingScore.Frame.mark_pins(3)

    assert BowlingScore.Frame.mark_pins(spare_frame, 0) == {:error, :invalid_frame_or_pin_score}
    assert BowlingScore.Frame.mark_pins(spare_frame, 3) == {:error, :invalid_frame_or_pin_score}
  end

  test "strike frame scoring" do
    {:ok, strike} = BowlingScore.Frame.create() |> BowlingScore.Frame.mark_pins(10)
    first_of_two = %{strike | carries: [10]}
    first_of_three = %{strike | carries: [10, 10]}

    assert BowlingScore.Frame.score(strike) == 10
    assert BowlingScore.Frame.score(first_of_two) == 20
    assert BowlingScore.Frame.score(first_of_three) == 30
  end

  test "spare and regular frame scoring" do
    {:ok, spare} =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)
      |> BowlingScore.Frame.mark_pins(3)

    regular =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(5)
      |> BowlingScore.Frame.mark_pins(3)

    spare_carry = %{spare | carries: [10]}

    assert BowlingScore.Frame.score(spare) == 10
    assert BowlingScore.Frame.score(regular) == 8
  end
end
