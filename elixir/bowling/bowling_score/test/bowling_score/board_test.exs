defmodule BowlingScore.BoardTest do
  use ExUnit.Case

  test "new board has one empty frame" do
    board = BowlingScore.Board.create()

    assert board == %BowlingScore.Board{
             frames: [BowlingScore.Frame.create()],
             score: 0,
             state: :in_progress
           }
  end

  test "add scored frame" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(7)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  %BowlingScore.Frame{carries: [], pin_slots: {7, :free}, slot_result: :regular}
                ],
                score: 0,
                state: :in_progress
              }}

    board =
      board
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(2)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  BowlingScore.Frame.create(),
                  %BowlingScore.Frame{carries: [], pin_slots: {7, 2}, slot_result: :regular}
                ],
                score: 9,
                state: :in_progress
              }}
  end

  test "only a strike can be added to empty active frame" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  BowlingScore.Frame.create(),
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 10,
                state: :in_progress
              }}
  end

  test "a spare completed frame cannot be added to empty active frame" do
    board = BowlingScore.Board.create()

    {:ok, scored_frame} =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(7)
      |> BowlingScore.Frame.mark_pins(3)

    scored_board = BowlingScore.Board.add_frame({:ok, {scored_frame, board}})

    assert scored_board == {:error, :invalid_completed_frame_expecting_partial}
  end

  test "a regular completed frame cannot be added to empty active frame" do
    board = BowlingScore.Board.create()

    {:ok, scored_frame} =
      BowlingScore.Frame.create()
      |> BowlingScore.Frame.mark_pins(4)
      |> BowlingScore.Frame.mark_pins(3)

    scored_board = BowlingScore.Board.add_frame({:ok, {scored_frame, board}})

    assert scored_board == {:error, :invalid_completed_frame_expecting_partial}
  end

  test "1/5 frame mini game with strike + regular" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {3, :free},
                    slot_result: :regular
                  },
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 10,
                state: :in_progress
              }}
  end

  test "1/5 frame mini game with spare + regular" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(7)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(4)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {4, :free},
                    slot_result: :regular
                  },
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {7, 3},
                    slot_result: :spare
                  }
                ],
                score: 10,
                state: :in_progress
              }}
  end

  test "2 frame mini game with strike + regular" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(6)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  BowlingScore.Frame.create(),
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {3, 6},
                    slot_result: :regular
                  },
                  %BowlingScore.Frame{
                    carries: [3, 6],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 28,
                state: :in_progress
              }}
  end

  test "2 frame mini game with spare + regular" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(7)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(4)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(2)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  BowlingScore.Frame.create(),
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {4, 2},
                    slot_result: :regular
                  },
                  %BowlingScore.Frame{
                    carries: [4],
                    pin_slots: {7, 3},
                    slot_result: :spare
                  }
                ],
                score: 20,
                state: :in_progress
              }}
  end

  test "3 frames with 'bakfast' (2 strikes in a row)" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(9)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(0)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  BowlingScore.Frame.create(),
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {9, 0},
                    slot_result: :regular
                  },
                  %BowlingScore.Frame{
                    carries: [9, 0],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 9],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 57,
                state: :in_progress
              }}
  end

  test "4 frames with 'turkey' (3 strikes in a row)" do
    board =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(0)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(9)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  BowlingScore.Frame.create(),
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {0, 9},
                    slot_result: :regular
                  },
                  %BowlingScore.Frame{
                    carries: [0, 9],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 0],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 78,
                state: :in_progress
              }}
  end

  test "nine strikes and a beagle" do
    board = BowlingScore.Board.create()

    {:ok, board} =
      1..9
      |> Enum.reduce(board, fn _, accum ->
        accum
        |> BowlingScore.Board.active_frame()
        |> BowlingScore.Board.mark_frame(10)
        |> BowlingScore.Board.add_frame()
      end)
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(0)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(0)
      |> BowlingScore.Board.add_frame()

    assert board.frames |> Enum.count() == 10

    assert board ==
             %BowlingScore.Board{
               frames: [
                 %BowlingScore.Frame{
                   carries: [],
                   pin_slots: {0, 0},
                   slot_result: :regular
                 },
                 %BowlingScore.Frame{
                   carries: [0, 0],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 0],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 10],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 10],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 10],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 10],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 10],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 10],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 },
                 %BowlingScore.Frame{
                   carries: [10, 10],
                   pin_slots: {10, :free},
                   slot_result: :strike
                 }
               ],
               score: 240,
               state: :completed
             }
  end

  test "nine strikes and spare" do
    board = BowlingScore.Board.create()

    {:ok, board} =
      1..9
      |> Enum.reduce(board, fn _, accum ->
        accum
        |> BowlingScore.Board.active_frame()
        |> BowlingScore.Board.mark_frame(10)
        |> BowlingScore.Board.add_frame()
      end)
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(7)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()

    assert board.frames |> Enum.count() == 11

    # final roll
    board =
      board
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(8)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {8, 0},
                    slot_result: :regular
                  },
                  %BowlingScore.Frame{
                    carries: [8],
                    pin_slots: {7, 3},
                    slot_result: :spare
                  },
                  %BowlingScore.Frame{
                    carries: [7, 3],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 7],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 275,
                state: :completed
              }}
  end

  test "ten strikes and spare" do
    board = BowlingScore.Board.create()

    {:ok, board} =
      1..9
      |> Enum.reduce(board, fn _, accum ->
        accum
        |> BowlingScore.Board.active_frame()
        |> BowlingScore.Board.mark_frame(10)
        |> BowlingScore.Board.add_frame()
      end)

    assert board.frames |> Enum.count() == 10

    # 10th strike roll
    board =
      board
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()

    # 11th spare rolls
    board =
      board
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(7)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {7, 3},
                    slot_result: :spare
                  },
                  %BowlingScore.Frame{
                    carries: [7, 3],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 7],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 287,
                state: :completed
              }}
  end

  test "twelve strikes, max score!" do
    board = BowlingScore.Board.create()

    {:ok, board} =
      1..9
      |> Enum.reduce(board, fn _, accum ->
        accum
        |> BowlingScore.Board.active_frame()
        |> BowlingScore.Board.mark_frame(10)
        |> BowlingScore.Board.add_frame()
      end)

    assert board.frames |> Enum.count() == 10

    # 10th strike roll
    board =
      board
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()

    # 11th and 12th strike rolls
    board =
      board
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()

    assert board ==
             {:ok,
              %BowlingScore.Board{
                frames: [
                  %BowlingScore.Frame{
                    carries: [],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  },
                  %BowlingScore.Frame{
                    carries: [10, 10],
                    pin_slots: {10, :free},
                    slot_result: :strike
                  }
                ],
                score: 300,
                state: :completed
              }}
  end

  test "running score of empty board" do
    score =
      BowlingScore.Board.create()
      |> BowlingScore.Board.running_score()

    assert score == [
             {%BowlingScore.Frame{
                carries: [],
                pin_slots: {:free, :free},
                slot_result: :regular
              }, 0}
           ]
  end

  test "running score for 2 frame strike + regular" do
    score =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(10)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(6)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.running_score()

    assert score == [
             {%BowlingScore.Frame{
                carries: [3, 6],
                pin_slots: {10, :free},
                slot_result: :strike
              }, 19},
             {%BowlingScore.Frame{
                carries: [],
                pin_slots: {3, 6},
                slot_result: :regular
              }, 28},
             {%BowlingScore.Frame{
                carries: [],
                pin_slots: {:free, :free},
                slot_result: :regular
              }, 0}
           ]
  end

  test "running score for 2 frame spare + regular" do
    score =
      BowlingScore.Board.create()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(7)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(3)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(4)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.active_frame()
      |> BowlingScore.Board.mark_frame(2)
      |> BowlingScore.Board.add_frame()
      |> BowlingScore.Board.running_score()

    assert score == [
             {%BowlingScore.Frame{
                carries: [4],
                pin_slots: {7, 3},
                slot_result: :spare
              }, 14},
             {%BowlingScore.Frame{
                carries: [],
                pin_slots: {4, 2},
                slot_result: :regular
              }, 20},
             {%BowlingScore.Frame{
                carries: [],
                pin_slots: {:free, :free},
                slot_result: :regular
              }, 0}
           ]
  end
end
