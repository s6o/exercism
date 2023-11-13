defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(count) when is_integer(count) and count > 0 do
    Stream.resource(fn -> {0, count, []} end, &next/1, fn _ -> :ok end)
    |> Enum.into([])
  end

  def generate(_), do: raise(ArgumentError, "count must be specified as an integer >= 1")

  defp next({index, count, numbers}) do
    case index do
      0 when count == 1 ->
        {[2], {index + 1, count, []}}

      0 when count > 1 ->
        {[2], {index + 1, count, []}}

      1 when count > 1 ->
        {[1], {index + 1, count, [1, 2]}}

      _ ->
        if index < count do
          [a, b | _] = numbers
          {[a + b], {index + 1, count, [a + b | numbers]}}
        else
          {:halt, numbers}
        end
    end
  end
end
