defmodule BowlingHall.RouterTest do
  use ExUnit.Case
  use Plug.Test

  @opts BowlingHall.Router.init([])

  test "it returns pong" do
    # Create a test connection
    conn = conn(:get, "/ping")

    # Invoke the plug
    conn = BowlingHall.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong!"
  end
end
