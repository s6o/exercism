defmodule Luhn do
  require Integer

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    cleaned = number |> String.replace(" ", "")

    cleaned
    |> String.split(~r{.}, include_captures: true, trim: true)
    |> Enum.take(String.length(cleaned) - 1)
    |> Enum.reduce_while({1, 0}, fn s, {idx, sum} ->
      is_digit = Enum.member?(digits, s)

      if is_digit do
        d = s |> String.to_integer()

        if idx |> Integer.is_even() do
          dsum = d * 2
          {:cont, {idx + 1, sum + if(dsum > 9, do: dsum - 9, else: dsum)}}
        else
          {:cont, {idx + 1, sum + d}}
        end
      else
        {:halt, {idx, sum}}
      end
    end)
    |> (fn {_, sum} ->
          case cleaned |> String.last() do
            nil ->
              false

            s ->
              case Integer.parse(s) do
                {check_digit, _} ->
                  10 - rem(sum, 10) == check_digit

                :error ->
                  false
              end
          end
        end).()
  end
end
