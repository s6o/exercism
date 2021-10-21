defmodule BowlingHall.RouterTest do
  use ExUnit.Case
  use Plug.Test

  @opts BowlingHall.Router.init([])

  test "it returns pong" do
    # Create a test connection
    conn =
      conn(:post, "/terminals", ~S())
      |> put_req_header("content-type", "application/json")

    # Invoke the plug
    conn = BowlingHall.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == ~S({"terminal_id":1})
  end
end
