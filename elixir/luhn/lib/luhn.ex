defmodule Luhn do
  require Integer

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    cleaned = number |> String.replace(" ", "")

    if cleaned == "0" do
      false
    else
      cleaned
      |> IO.inspect(label: "cleaned")
      |> String.split(~r{.}, include_captures: true, trim: true)
      |> IO.inspect(label: "splitted")
      |> Enum.reduce_while({1, 0}, fn s, {idx, sum} ->
        is_digit = Enum.member?(digits, s)

        if is_digit do
          d = s |> String.to_integer() |> IO.inspect(label: "digit")

          if idx |> Integer.is_even() do
            dsum = d * 2

            {:cont, {idx + 1, sum + if(dsum > 9, do: dsum - 9, else: dsum)}}
            |> IO.inspect(label: "event, digit")
          else
            {:cont, {idx + 1, sum + d}} |> IO.inspect(label: "odd, digit")
          end
        else
          {:halt, {idx, sum}}
        end
      end)
      |> (fn {_, sum} ->
            IO.inspect(sum, label: "sum")
            rem(sum, 10) == 0
          end).()
    end
  end
end
