defmodule BowlingScore.FrameTest do
  use ExUnit.Case

  test "new frame" do
    assert BowlingScore.Frame.create() == %BowlingScore.Frame{
             pin_slots: {:free, :free},
             score: 0,
             slot_result: :regular
           }
  end

  test "valid strike scoring" do
    frame = BowlingScore.Frame.create()

    assert BowlingScore.Frame.mark_pins(frame, 10) ==
             {:ok,
              %BowlingScore.Frame{
                pin_slots: {10, :free},
                score: 10,
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
                pin_slots: {7, :free},
                score: 7,
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
                pin_slots: {7, :free},
                score: 7,
                slot_result: :regular
              }}

    assert BowlingScore.Frame.mark_pins(frame, 3) ==
             {:ok,
              %BowlingScore.Frame{
                pin_slots: {7, 3},
                score: 10,
                slot_result: :spare
              }}
  end

  test "valid regular scoring ending in regular frame" do
    frame =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)
      |> BowlingScore.Frame.mark_pins(2)

    assert frame == {:ok, %BowlingScore.Frame{pin_slots: {7, 2}, score: 9, slot_result: :regular}}
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
end
