defmodule HelloSocketsWeb.StatsSocket do
  use Phoenix.Socket

  channel("*", HelloSocketsWeb.StatsChannel)
  transport(:websocket, Phoenix.Transports.WebSocket)

  def connect(_params, socket) do
    HelloSockets.Statix.increment("socket_connect", 1,
      tags: ["status:success", "socket:StatsSocket"]
    )

    {:ok, socket}
  end

  def id(_socket), do: nil
end
