defmodule HelloSocketsWeb.WildcardChannel do
  use Phoenix.Channel
  require Logger

  def join("wild:" <> numbers, _payload, socket) do
    try do
      if numbers_correct?(numbers) do
        {:ok, socket}
      else
        {:error, %{}}
      end
    rescue
      e ->
        Logger.error("[error] an exception was raised")
        {:error, %{exception: e}}
    end
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  defp numbers_correct?(numbers) do
    numbers
    |> String.split(":")
    |> Enum.map(&String.to_integer/1)
    |> case do
      [a, b] when b == a * 2 -> true
      _ -> false
    end
  end
end
