defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    space_cleaned = number |> String.replace(" ", "")
    digit_cleaned = number |> String.replace(~r/[^\d]/, "")

    if space_cleaned != digit_cleaned or String.length(digit_cleaned) == 1 do
      false
    else
      digit_cleaned
      |> String.split(~r{.}, include_captures: true, trim: true)
      |> List.foldr({0, 0}, fn s, {idx, sum} ->
        d = String.to_integer(s)

        if rem(idx, 2) == 1 do
          dsum = d * 2
          {idx + 1, sum + if(dsum > 9, do: dsum - 9, else: dsum)}
        else
          {idx + 1, sum + d}
        end
      end)
      |> (fn {_, sum} -> rem(sum, 10) == 0 end).()
    end
  end
end
