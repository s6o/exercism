defmodule BowlingTerminalTest do
  use ExUnit.Case
  doctest BowlingTerminal

  test "greets the world" do
    assert BowlingTerminal.hello() == :world
  end
end
