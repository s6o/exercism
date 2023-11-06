defmodule HelloSocketsWeb.PingChannel do
  use Phoenix.Channel

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  def handle_in("ping", %{"ack_phrase" => ack_phrase}, socket) do
    {:reply, {:ok, %{ping: ack_phrase}}, socket}
  end

  def handle_in("ping:" <> phrase, _payload, socket) do
    {:reply, {:ok, %{ping: phrase}}, socket}
  end

  # We only handle ping
  def handle_in("pong", _payload, socket) do
    {:noreply, socket}
  end

  def handle_in("ding", _payload, socket) do
    {:stop, :shutdown, {:ok, %{msg: "shutting down"}}, socket}
  end
end
