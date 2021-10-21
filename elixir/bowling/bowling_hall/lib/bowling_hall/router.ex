defmodule BowlingHall.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  # List terminals and their respective states.
  get "/terminals" do
    results = BowlingHall.GameServer.list_terminals()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(results))
  end

  # Try to register a new terminal with specified id.
  post "/terminals" do
    new_terminal_id = BowlingHall.GameServer.register_terminal()

    result = %{
      "terminal_id" => new_terminal_id
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Jason.encode!(result))
  end

  # Get game state on specifed terminal
  get "/games/:terminal_id" do
    %Plug.Conn{path_params: %{"terminal_id" => terminal_id}} = conn

    {tid, _} = Integer.parse(terminal_id)

    case BowlingHall.GameServer.game_state(tid) do
      :no_game ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(409, Jason.encode!("No active game on terminal: #{terminal_id}"))

      :unknown_terminal ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!("Unknown terminal id."))

      game_state ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(game_state))
    end
  end

  # Start new game for specified terminal
  post "/games/:terminal_id" do
    %Plug.Conn{body_params: %{"_json" => players}, path_params: %{"terminal_id" => terminal_id}} =
      conn

    {tid, _} = Integer.parse(terminal_id)

    if is_list(players) == true && Enum.count(players) > 0 do
      case BowlingHall.GameServer.new_game(tid, players) do
        :unknown_terminal ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(404, Jason.encode!("Unknown terminal id."))

        game_state ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(201, Jason.encode!(game_state))
      end
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(400, Jason.encode!("A list of player names is required."))
    end
  end

  # Update downed pins for specified terminal
  put "/games/:terminal_id" do
    %Plug.Conn{body_params: %{"pins_down" => pins}, path_params: %{"terminal_id" => terminal_id}} =
      conn

    {tid, _} = Integer.parse(terminal_id)

    case BowlingHall.GameServer.mark_pins(tid, pins) do
      %BowlingHall.TerminalGame{} = tg ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(tg))

      :no_game ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(409, Jason.encode!("No active game on terminal: #{terminal_id}"))

      :unknown_terminal ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!("Unknown terminal id."))

      {:error, term} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(to_string(term)))
    end
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
