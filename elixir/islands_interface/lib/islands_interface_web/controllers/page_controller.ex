defmodule IslandsInterfaceWeb.PageController do
  use IslandsInterfaceWeb, :controller

  alias IslandsEngine.GameSupervisor

  def home(conn, _params) do
    render(conn, :home)
  end

  def new_game(conn, %{"player1" => player1}) do
    {:ok, _pid} = GameSupervisor.start_game(player1)

    conn
    |> put_flash(:info, "You entered the name: " <> player1)
    |> render(:home)
  end
end
