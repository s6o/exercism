defmodule BowlingTerminal.GameServer do
  @moduledoc """
  HTTP client to communicate with a Bowling Hall game server.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://localhost:3001")
  plug(Tesla.Middleware.JSON)

  def register() do
    with {:ok, %Tesla.Env{} = response} <- post("/terminals", []) do
      if response.status == 201 do
        {:ok, response.body}
      end
    end
  end

  def terminals() do
    with {:ok, %Tesla.Env{} = response} <- get("/terminals") do
      if response.status == 200 do
        {:ok, response.body}
      end
    end
  end

  def new_game(terminal_id, players) do
    with {:ok, %Tesla.Env{} = response} <- post("/games/#{terminal_id}", players) do
      if response.status == 201 do
        {:ok, response.body}
      end
    end
  end

  def game_state(terminal_id) do
    with {:ok, %Tesla.Env{} = response} <- get("/games/#{terminal_id}") do
      if response.status == 200 do
        {:ok, response.body}
      end
    end
  end

  def mark_pins(terminal_id, pins) do
    with {:ok, %Tesla.Env{} = response} <- put("/games/#{terminal_id}", %{"pins_down" => pins}) do
      if response.status == 200 do
        {:ok, response.body}
      end
    end
  end
end
