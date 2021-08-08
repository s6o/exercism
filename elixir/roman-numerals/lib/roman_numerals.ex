defmodule RomanNumerals do
  use Publicist

  @numeral_order %{
    1 => "I",
    5 => "V",
    10 => "X",
    50 => "L",
    100 => "C",
    500 => "D",
    1000 => "M",
    5000 => "Ṽ",
    # for X with horizontal line above
    10000 => "Ξ"
  }

  @weight_ranges %{
    1 => {1, 5, 10},
    10 => {10, 50, 100},
    100 => {100, 500, 1000},
    1000 => {1000, 5000, 10000}
  }

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    {_, result} =
      number
      |> Integer.to_string()
      |> String.reverse()
      |> String.split(~r{\d}, include_captures: true, trim: true)
      |> Enum.reduce({1, []}, fn an, {weight, nums} ->
        if an == "0" do
          {weight * 10, nums}
        else
          {weight * 10, [digit_to_numeral(an, weight) | nums]}
        end
      end)

    result
    |> Enum.join()
  end

  defp digit_to_numeral(digit, weight) do
    {n, _} = Integer.parse(digit)
    number = n * weight

    if Map.has_key?(@numeral_order, number) do
      @numeral_order[number]
    else
      {pad, middle, sub_from} = @weight_ranges[weight]

      cond do
        number > pad and number < middle - weight ->
          String.pad_trailing(
            @numeral_order[pad],
            div(number, weight),
            @numeral_order[pad]
          )

        number >= middle - weight and number < middle ->
          String.pad_leading(
            @numeral_order[middle],
            div(middle, weight) - div(number, weight) + 1,
            @numeral_order[pad]
          )

        number > middle and number < sub_from - weight ->
          String.pad_trailing(
            @numeral_order[middle],
            4 - (div(sub_from - weight, weight) - div(number, weight)) + 1,
            @numeral_order[pad]
          )

        number >= sub_from - weight and number < sub_from ->
          String.pad_leading(
            @numeral_order[sub_from],
            div(sub_from, weight) - div(number, weight) + 1,
            @numeral_order[pad]
          )

        true ->
          ""
      end
    end
  end
end
