defmodule BowlingScore.GameTest do
  use ExUnit.Case

  test "create a game" do
    assert BowlingScore.Game.create() == %BowlingScore.Game{
             players: %{},
             pindex: 0,
             state: :registration
           }
  end

  test "a game cannot start without players" do
    game =
      {:ok, BowlingScore.Game.create()}
      |> BowlingScore.Game.start()

    assert game == {:error, :game_missing_players}
  end

  test "create player - Alice" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
                          slot_result: :regular
                        }
                      ],
                      score: 0,
                      state: :in_progress
                    }
                  }
                },
                pindex: 0,
                state: :registration
              }}
  end

  test "players to a game cannot be added after start" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.start()
      |> BowlingScore.Game.add_player("Bob")

    assert game == {:error, :game_already_in_progress}
  end

  test "start single player game" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.start()

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
                          slot_result: :regular
                        }
                      ],
                      score: 0,
                      state: :in_progress
                    }
                  }
                },
                pindex: 1,
                state: :in_progress
              }}
  end

  test "single player game, play to 2 frames: strike + regular" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.start()
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(3)
      |> BowlingScore.Game.mark_player_frame(6)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
                          slot_result: :regular
                        },
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
                    }
                  }
                },
                pindex: 1,
                state: :in_progress
              }}
  end

  test "single player game, no strikes" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.start()
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        }
                      ],
                      score: 80,
                      state: :completed
                    }
                  }
                },
                pindex: 0,
                state: :completed
              }}
  end

  test "single player game, for last sparce, no strikes" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.start()
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(2)
      |> BowlingScore.Game.mark_player_frame(8)
      |> BowlingScore.Game.mark_player_frame(0)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [8],
                          pin_slots: {8, 2},
                          slot_result: :spare
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {8, 0},
                          slot_result: :regular
                        }
                      ],
                      score: 90,
                      state: :completed
                    }
                  }
                },
                pindex: 0,
                state: :completed
              }}
  end

  test "single player game, max score!" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.start()
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
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
                    }
                  }
                },
                pindex: 0,
                state: :completed
              }}
  end

  test "two player, player switch" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.add_player("Bob")
      |> BowlingScore.Game.start()
      |> BowlingScore.Game.mark_player_frame(10)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
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
                    }
                  },
                  2 => %BowlingScore.Player{
                    name: "Bob",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
                          slot_result: :regular
                        }
                      ],
                      score: 0,
                      state: :in_progress
                    }
                  }
                },
                pindex: 2,
                state: :in_progress
              }}

    game = game |> BowlingScore.Game.mark_player_frame(3)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
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
                    }
                  },
                  2 => %BowlingScore.Player{
                    name: "Bob",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {3, :free},
                          slot_result: :regular
                        }
                      ],
                      score: 0,
                      state: :in_progress
                    }
                  }
                },
                pindex: 2,
                state: :in_progress
              }}

    game = game |> BowlingScore.Game.mark_player_frame(6)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
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
                    }
                  },
                  2 => %BowlingScore.Player{
                    name: "Bob",
                    board: %BowlingScore.Board{
                      frames: [
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {:free, :free},
                          slot_result: :regular
                        },
                        %BowlingScore.Frame{
                          carries: [],
                          pin_slots: {3, 6},
                          slot_result: :regular
                        }
                      ],
                      score: 9,
                      state: :in_progress
                    }
                  }
                },
                pindex: 1,
                state: :in_progress
              }}
  end

  test "two player game, max scores!" do
    game =
      BowlingScore.Game.create()
      |> BowlingScore.Game.add_player("Alice")
      |> BowlingScore.Game.add_player("Bob")
      |> BowlingScore.Game.start()
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)
      |> BowlingScore.Game.mark_player_frame(10)

    assert game ==
             {:ok,
              %BowlingScore.Game{
                players: %{
                  1 => %BowlingScore.Player{
                    name: "Alice",
                    board: %BowlingScore.Board{
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
                    }
                  },
                  2 => %BowlingScore.Player{
                    name: "Bob",
                    board: %BowlingScore.Board{
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
                    }
                  }
                },
                pindex: 0,
                state: :completed
              }}
  end
end
