defmodule CounterTest do
  use ExUnit.Case
  doctest Counter.Core

  test "Counter start, tick and state" do
    pid = Counter.start(100)
    assert is_pid(pid)
    {:tick, _pid} = Counter.tick(pid)

    state = Counter.state(pid)
    assert state == 101
  end
end
