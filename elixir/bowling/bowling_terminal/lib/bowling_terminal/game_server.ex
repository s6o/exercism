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
end
