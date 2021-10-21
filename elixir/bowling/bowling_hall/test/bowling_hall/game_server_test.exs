defmodule BowlingHall.GameServerTest do
  use ExUnit.Case

  test "mark a frame with invalid pins" do
    terminal_id = BowlingHall.GameServer.register_terminal()

    BowlingHall.GameServer.new_game(terminal_id, ["Bob"])

    BowlingHall.GameServer.mark_pins(terminal_id, 8)

    result = BowlingHall.GameServer.mark_pins(terminal_id, 8)
    assert result == {:error, :invalid_frame_or_pin_score}
  end
end
